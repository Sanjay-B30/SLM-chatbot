"""
app.py — On-Premise SLM Chatbot
Gemma 2B-Instruct via Ollama | MySQL | Flask | JWT RBAC
"""

import re
import json
import hashlib
import requests
from flask import Flask, request, jsonify, render_template

from config import OLLAMA_URL, OLLAMA_MODEL, DEBUG, PORT
from auth   import generate_token, login_required
from db     import execute_query, log_audit, get_connection

# ─────────────────────────────────────────────────────────
# App init
# ─────────────────────────────────────────────────────────
app = Flask(__name__)

# Load full schema context once at startup
with open("schema_context_full.txt", "r", encoding="utf-8") as f:
    FULL_SCHEMA = f.read()

# ─────────────────────────────────────────────────────────
# Role → allowed tables/views (Row-Level Security)
# ─────────────────────────────────────────────────────────
ROLE_TABLES = {
    "admin":      None,   # None = unrestricted
    "sales":      ["SalesOrders","SalesOrderItems","SalesReturns","Customers",
                   "Products","Categories","v_SalesOrders","Employees","Departments"],
    "inventory":  ["Inventory","Products","Categories","Warehouses","StockMovements",
                   "v_InventoryStatus","Employees"],
    "finance":    ["FinancialTransactions","Accounts","Payroll","Expenses",
                   "v_FinancialSummary","Departments","Employees"],
    "hr":         ["Employees","Departments","Shifts","LeaveTypes","LeaveEligibility",
                   "LeaveTransactions","Attendance","Payroll","Qualifications"],
    "management": ["v_SalesOrders","v_InventoryStatus","v_FinancialSummary",
                   "v_ManagementKPI","SalesOrders","Employees","Departments",
                   "Products","Customers","Payroll","Expenses"],
}

# ─────────────────────────────────────────────────────────
# SQL Security
# ─────────────────────────────────────────────────────────
BLOCKED_KEYWORDS = re.compile(
    r"\b(INSERT|UPDATE|DELETE|DROP|TRUNCATE|ALTER|CREATE|EXEC|EXECUTE|"
    r"GRANT|REVOKE|UNION\s+ALL|INTO\s+OUTFILE|LOAD_FILE|BENCHMARK|SLEEP)\b",
    re.IGNORECASE
)

def _extract_sql(raw: str) -> str:
    """Pull just the SQL from model output (handles markdown fences)."""
    # Try ```sql ... ``` block
    fence = re.search(r"```(?:sql)?\s*([\s\S]+?)```", raw, re.IGNORECASE)
    if fence:
        return fence.group(1).strip()
    # Try first SELECT … ; block
    sel = re.search(r"(SELECT[\s\S]+?;)", raw, re.IGNORECASE)
    if sel:
        return sel.group(1).strip()
    return raw.strip()


def _validate_sql(sql: str, role: str) -> tuple[bool, str]:
    """
    Returns (is_safe, reason).
    Checks:
      1. Must start with SELECT
      2. No dangerous DML/DDL keywords
      3. Only accesses tables allowed for this role
    """
    if not sql.lower().lstrip().startswith("select"):
        return False, "Only SELECT queries are allowed."

    if BLOCKED_KEYWORDS.search(sql):
        return False, "Query contains forbidden keywords."

    allowed = ROLE_TABLES.get(role)
    if allowed is not None:
        # Extract table/view names from SQL (rough but effective)
        found_tables = re.findall(
            r"(?:FROM|JOIN)\s+([`\w]+)", sql, re.IGNORECASE
        )
        for tbl in found_tables:
            tbl_clean = tbl.strip("`")
            if not any(a.lower() == tbl_clean.lower() for a in allowed):
                return False, f"Access denied: table '{tbl_clean}' is not allowed for your role."

    return True, ""


# ─────────────────────────────────────────────────────────
# Ollama helper
# ─────────────────────────────────────────────────────────
def _ollama(prompt: str, temperature: float = 0.1) -> str:
    """Call Ollama inference endpoint and return response text."""
    try:
        resp = requests.post(
            f"{OLLAMA_URL}/api/generate",
            json={
                "model":       OLLAMA_MODEL,
                "prompt":      prompt,
                "stream":      False,
                "options":     {"temperature": temperature, "num_predict": 512},
            },
            timeout=120,
        )
        resp.raise_for_status()
        return resp.json().get("response", "").strip()
    except requests.exceptions.ConnectionError:
        raise RuntimeError("Cannot connect to Ollama. Make sure Ollama is running.")
    except requests.exceptions.Timeout:
        raise RuntimeError("Ollama response timed out.")


# ─────────────────────────────────────────────────────────
# System prompt builder
# ─────────────────────────────────────────────────────────
def _build_sql_prompt(question: str, role: str, region: str = None, dept_id: int = None) -> str:
    allowed = ROLE_TABLES.get(role)
    allowed_str = ", ".join(allowed) if allowed else "ALL tables"

    rls_hint = ""
    if role == "sales" and region:
        rls_hint = f"\nIMPORTANT: This user's region is '{region}'. Always add WHERE Region = '{region}' for SalesOrders queries unless the question specifically asks for all regions."
    if role in ("hr","finance","inventory") and dept_id:
        rls_hint = f"\nIMPORTANT: This user belongs to DeptID {dept_id}."

    return f"""You are an expert MySQL SQL generator for a business analytics chatbot.

DATABASE SCHEMA:
{FULL_SCHEMA}

ROLE: {role.upper()}
ALLOWED TABLES/VIEWS: {allowed_str}{rls_hint}

RULES (MUST FOLLOW):
1. Generate ONLY a single valid MySQL SELECT query — nothing else.
2. Do NOT generate INSERT, UPDATE, DELETE, DROP, or any DDL.
3. Do NOT add explanations, comments, or markdown — return ONLY raw SQL ending with semicolon.
4. Use only the tables/views listed in ALLOWED TABLES/VIEWS.
5. For date comparisons always use MySQL syntax: MONTH(), YEAR(), CURDATE(), DATE_FORMAT().
6. Use JOINs to get human-readable names (e.g. DeptName, ProductName, CustomerName).
7. Limit results to 50 rows using LIMIT 50 unless the question asks for a total/count.
8. If question cannot be answered from the schema, return: SELECT 'I cannot answer this question from the available data.' AS Message;

USER QUESTION: {question}

SQL QUERY:"""


def _build_explain_prompt(question: str, sql: str, columns: list, rows: list) -> str:
    # Format results as a compact table string (max 20 rows for context)
    result_preview = ""
    if rows:
        header = " | ".join(columns)
        result_preview = header + "\n"
        result_preview += "-" * len(header) + "\n"
        for row in rows[:20]:
            result_preview += " | ".join(str(v) if v is not None else "NULL" for v in row) + "\n"
        if len(rows) > 20:
            result_preview += f"... ({len(rows) - 20} more rows)\n"
    else:
        result_preview = "(No results returned)"

    return f"""You are a helpful business analytics assistant. Explain the following SQL query result in clear, concise natural language suitable for a business user. Be specific about numbers and names. Do not show the SQL.

Question asked: {question}

Query result:
{result_preview}

Provide a short, professional 2-4 sentence summary of what the data shows:"""


# ─────────────────────────────────────────────────────────
# Routes
# ─────────────────────────────────────────────────────────

@app.route("/")
def home():
    return render_template("index.html")


@app.route("/login", methods=["POST"])
def login():
    data     = request.get_json(force=True)
    username = data.get("username", "").strip()
    password = data.get("password", "").strip()

    if not username or not password:
        return jsonify({"error": "Username and password required"}), 400

    pwd_hash = hashlib.sha256(password.encode()).hexdigest()

    try:
        cols, rows = execute_query(
            """
            SELECT u.UserID, u.Username, u.FullName, r.RoleName,
                   u.Region, u.DeptID, u.IsActive
            FROM AppUsers u
            JOIN Roles r ON u.RoleID = r.RoleID
            WHERE u.Username = %s AND u.PasswordHash = %s
            """,
            (username, pwd_hash)
        )
    except RuntimeError as e:
        return jsonify({"error": str(e)}), 500

    if not rows:
        return jsonify({"error": "Invalid username or password"}), 401

    user_id, uname, full_name, role, region, dept_id, is_active = rows[0]

    if not is_active:
        return jsonify({"error": "Account is disabled. Contact administrator."}), 403

    # Update last login
    try:
        conn = get_connection()
        c = conn.cursor()
        c.execute("UPDATE AppUsers SET LastLogin = NOW() WHERE UserID = %s", (user_id,))
        c.close(); conn.close()
    except Exception:
        pass

    token = generate_token(user_id, uname, role, region, dept_id)
    return jsonify({
        "token":    token,
        "username": uname,
        "fullName": full_name,
        "role":     role,
        "region":   region,
    })


@app.route("/chat", methods=["POST"])
@login_required
def chat():
    user    = request.current_user
    data    = request.get_json(force=True)
    question = data.get("message", "").strip()
    ip      = request.remote_addr

    if not question:
        return jsonify({"error": "Message cannot be empty"}), 400

    role     = user["role"]
    region   = user.get("region")
    dept_id  = user.get("dept_id")
    username = user["username"]
    user_id  = user["user_id"]

    # ── Step 1: Generate SQL ──────────────────────────────
    sql_prompt = _build_sql_prompt(question, role, region, dept_id)
    try:
        raw_sql = _ollama(sql_prompt, temperature=0.05)
    except RuntimeError as e:
        return jsonify({"error": str(e), "reply": str(e)}), 503

    sql = _extract_sql(raw_sql)

    # ── Step 2: Validate SQL ──────────────────────────────
    is_safe, reason = _validate_sql(sql, role)
    if not is_safe:
        log_audit(user_id, username, role, question, sql, "Blocked", reason, 0, ip)
        return jsonify({
            "reply": f"⚠️ Query was blocked for security reasons: {reason}",
            "sql":   sql,
            "rows":  [],
            "columns": [],
        })

    # ── Step 3: Execute SQL ───────────────────────────────
    try:
        columns, rows = execute_query(sql)
    except RuntimeError as e:
        log_audit(user_id, username, role, question, sql, "Error", str(e), 0, ip)
        return jsonify({
            "reply":   f"❌ Could not execute the query. The AI may have generated invalid SQL. Please rephrase your question.\n\nTechnical detail: {e}",
            "sql":     sql,
            "rows":    [],
            "columns": [],
        })

    # ── Step 4: Explain results in natural language ───────
    explain_prompt = _build_explain_prompt(question, sql, columns, rows)
    try:
        answer = _ollama(explain_prompt, temperature=0.3)
    except RuntimeError:
        answer = f"Query returned {len(rows)} row(s)."

    # ── Step 5: Log audit trail ───────────────────────────
    log_audit(user_id, username, role, question, sql, "Success", None, len(rows), ip)

    # Serialize rows (handle non-JSON-serializable types like datetime)
    serialized_rows = []
    for row in rows[:100]:   # cap at 100 rows for frontend
        serialized_rows.append([str(v) if v is not None else None for v in row])

    return jsonify({
        "reply":   answer,
        "sql":     sql,
        "columns": columns,
        "rows":    serialized_rows,
    })


@app.route("/audit", methods=["GET"])
@login_required
def audit_log():
    """Admin-only: view recent audit logs."""
    user = request.current_user
    if user["role"] != "admin":
        return jsonify({"error": "Access denied: Admin role required"}), 403

    try:
        cols, rows = execute_query(
            """SELECT LogID, Username, UserRole, LEFT(Question,80) AS Question,
                      ExecutionStatus, RowsReturned, LoggedAt
               FROM AuditLog ORDER BY LoggedAt DESC LIMIT 100"""
        )
    except RuntimeError as e:
        return jsonify({"error": str(e)}), 500

    data = [dict(zip(cols, [str(v) if v else "" for v in row])) for row in rows]
    return jsonify(data)


@app.route("/health", methods=["GET"])
def health():
    """Quick health-check endpoint."""
    try:
        execute_query("SELECT 1")
        db_ok = True
    except Exception:
        db_ok = False

    try:
        r = requests.get(f"{OLLAMA_URL}/api/tags", timeout=5)
        ollama_ok = r.status_code == 200
    except Exception:
        ollama_ok = False

    return jsonify({
        "database": "ok" if db_ok else "error",
        "ollama":   "ok" if ollama_ok else "error",
        "model":    OLLAMA_MODEL,
    })


# ─────────────────────────────────────────────────────────
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=DEBUG)