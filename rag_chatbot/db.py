import mysql.connector
import mysql.connector.pooling
from config import DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME

# ── Lazy connection pool (thread-safe) ───────────────────
# Pool is created on first use so a bad password doesn't crash import.
_pool = None

def _get_pool():
    global _pool
    if _pool is None:
        _pool = mysql.connector.pooling.MySQLConnectionPool(
            pool_name="chatbot_pool",
            pool_size=5,
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            autocommit=True,
        )
    return _pool


def get_connection():
    """Get a connection from the pool."""
    return _get_pool().get_connection()


def execute_query(sql: str, params: tuple = None):
    """
    Execute a SQL query and return (columns, rows).
    Raises ValueError for forbidden keywords.
    Raises RuntimeError for SQL execution errors.
    """
    conn = get_connection()
    try:
        cursor = conn.cursor()
        if params:
            cursor.execute(sql, params)
        else:
            cursor.execute(sql)
        columns = [desc[0] for desc in cursor.description] if cursor.description else []
        rows    = cursor.fetchall()
        return columns, rows
    except mysql.connector.Error as e:
        raise RuntimeError(f"Database error: {e.msg}") from e
    finally:
        cursor.close()
        conn.close()


def log_audit(user_id, username, role, question, sql, status, error_msg=None, rows=0, ip=None):
    """Write an entry to the AuditLog table."""
    conn = get_connection()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """INSERT INTO AuditLog
               (UserID, Username, UserRole, Question, GeneratedSQL,
                ExecutionStatus, ErrorMessage, RowsReturned, IPAddress)
               VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
            (user_id, username, role, question, sql, status, error_msg, rows, ip)
        )
    except Exception:
        pass   # audit failures must never crash the app
    finally:
        cursor.close()
        conn.close()
