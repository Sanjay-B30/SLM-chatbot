/* ─────────────────────────────────────────────────────────
   chat.js — InsightBot v2
   Chat history (localStorage) + redesigned UI logic
   ───────────────────────────────────────────────────────── */

// ── State ──────────────────────────────────────────────────
let authToken   = null;
let currentUser = {};
let currentSessionId = null;   // active chat session ID

// ── Chat history key in localStorage ───────────────────────
function historyKey() {
  return `insightbot_history_${currentUser.username || "guest"}`;
}

// ── Session helpers ────────────────────────────────────────
function loadAllSessions() {
  try {
    return JSON.parse(localStorage.getItem(historyKey()) || "[]");
  } catch { return []; }
}

function saveAllSessions(sessions) {
  localStorage.setItem(historyKey(), JSON.stringify(sessions));
}

function getSession(id) {
  return loadAllSessions().find((s) => s.id === id) || null;
}

function createSession() {
  const id = "s_" + Date.now();
  const session = {
    id,
    title: "New Chat",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    messages: [],   // [{role, text, sql, columns, rows, time}]
  };
  const sessions = [session, ...loadAllSessions()];
  // Cap at 30 sessions
  saveAllSessions(sessions.slice(0, 30));
  return session;
}

function updateSessionMessages(id, messages, title) {
  const sessions = loadAllSessions();
  const idx = sessions.findIndex((s) => s.id === id);
  if (idx === -1) return;
  sessions[idx].messages = messages;
  sessions[idx].updatedAt = new Date().toISOString();
  if (title) sessions[idx].title = title;
  saveAllSessions(sessions);
}

function deleteSession(id) {
  const sessions = loadAllSessions().filter((s) => s.id !== id);
  saveAllSessions(sessions);
  if (currentSessionId === id) {
    startNewChat();
  } else {
    renderSessionsList();
  }
}

// In-memory messages for the active session
let activeMessages = [];

function pushMessage(msg) {
  activeMessages.push(msg);
  // Derive title from first user message
  const firstUserMsg = activeMessages.find((m) => m.role === "user");
  const title = firstUserMsg
    ? (firstUserMsg.text.length > 42 ? firstUserMsg.text.slice(0, 42) + "…" : firstUserMsg.text)
    : "New Chat";
  updateSessionMessages(currentSessionId, activeMessages, title);
  renderSessionsList();
}

// ── Quick questions per role ───────────────────────────────
const QUICK_QUESTIONS = {
  admin: [
    "Show all employees list",
    "How many orders were placed this month?",
    "What is total sales revenue this year?",
    "List all users in the system",
    "Show recent audit logs",
  ],
  sales: [
    "Show my region's sales this month",
    "Which customers have the highest orders?",
    "List all confirmed orders",
    "What are the top selling products?",
    "Show pending and draft orders",
  ],
  inventory: [
    "Which products are low on stock?",
    "Show inventory status for all products",
    "List all products in Chennai warehouse",
    "Which products need to be reordered?",
    "Show stock movements this month",
  ],
  finance: [
    "What is total revenue this month?",
    "Show all pending payroll",
    "List all expenses this month",
    "What is the total GST payable?",
    "Show accounts receivable balance",
  ],
  hr: [
    "How many employees are active?",
    "Show employees in Sales department",
    "List pending leave applications",
    "Who joined this year?",
    "Show department wise employee count",
  ],
  management: [
    "Show KPI summary dashboard",
    "What is total sales vs last month?",
    "How many low stock items are there?",
    "Show department wise headcount",
    "What is total payroll cost this month?",
  ],
};

// ── DOM helpers ────────────────────────────────────────────
const $ = (id) => document.getElementById(id);

function showScreen(name) {
  document.querySelectorAll(".screen").forEach((s) => s.classList.remove("active"));
  $(name + "Screen").classList.add("active");
}

function formatTime(iso) {
  const d = iso ? new Date(iso) : new Date();
  return d.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" });
}

function formatRelativeDate(iso) {
  if (!iso) return "";
  const d = new Date(iso);
  const now = new Date();
  const diff = now - d;
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  const days = Math.floor(hrs / 24);
  if (days === 1) return "yesterday";
  if (days < 7) return `${days}d ago`;
  return d.toLocaleDateString();
}

// ── Password toggle ────────────────────────────────────────
function togglePassword() {
  const inp = $("passwordInput");
  inp.type = inp.type === "password" ? "text" : "password";
}

// ── Login ──────────────────────────────────────────────────
function fillDemo(user, pass) {
  $("usernameInput").value = user;
  $("passwordInput").value = pass;
}

$("loginForm").addEventListener("submit", async (e) => {
  e.preventDefault();
  const username = $("usernameInput").value.trim();
  const password = $("passwordInput").value.trim();

  $("loginBtnText").textContent = "Signing in…";
  $("loginSpinner").classList.remove("hidden");
  $("loginBtn").disabled = true;
  $("loginError").classList.add("hidden");

  try {
    const res  = await fetch("/login", {
      method:  "POST",
      headers: { "Content-Type": "application/json" },
      body:    JSON.stringify({ username, password }),
    });
    const data = await res.json();

    if (!res.ok) {
      showLoginError(data.error || "Login failed. Please try again.");
      return;
    }

    authToken   = data.token;
    currentUser = {
      username: data.username,
      fullName: data.fullName,
      role: data.role,
      region: data.region,
    };
    sessionStorage.setItem("token", authToken);
    sessionStorage.setItem("user",  JSON.stringify(currentUser));

    await initChatScreen(true);
    showScreen("chat");
  } catch {
    showLoginError("Cannot reach the server. Make sure Flask is running.");
  } finally {
    $("loginBtnText").textContent = "Sign In";
    $("loginSpinner").classList.add("hidden");
    $("loginBtn").disabled = false;
  }
});

function showLoginError(msg) {
  const el = $("loginError");
  el.textContent = msg;
  el.classList.remove("hidden");
}

// ── Resume session ─────────────────────────────────────────
window.addEventListener("DOMContentLoaded", () => {
  const savedToken = sessionStorage.getItem("token");
  const savedUser  = sessionStorage.getItem("user");
  if (savedToken && savedUser) {
    authToken   = savedToken;
    currentUser = JSON.parse(savedUser);
    initChatScreen(false);
    showScreen("chat");
  } else {
    showScreen("login");
  }
});

// ── Init chat screen ───────────────────────────────────────
async function initChatScreen(isNewLogin = false) {
  const { fullName, username, role } = currentUser;
  const initial = (fullName || username || "U")[0].toUpperCase();

  $("userAvatarSidebar").textContent = initial;
  $("userNameSidebar").textContent   = fullName || username;
  $("userRoleBadge").textContent     = role.toUpperCase();

  // Role badge colour
  const roleColors = {
    admin:      "#f59e0b",
    sales:      "#22c55e",
    inventory:  "#06b6d4",
    finance:    "#a78bfa",
    hr:         "#ec4899",
    management: "#6366f1",
  };
  const rc = roleColors[role] || "#9394b0";
  const rb = $("userRoleBadge");
  rb.style.color           = rc;
  rb.style.borderColor     = rc + "44";
  rb.style.backgroundColor = rc + "18";

  // Quick questions
  const qs = QUICK_QUESTIONS[role] || QUICK_QUESTIONS.admin;
  const ql = $("quickQuestions");
  ql.innerHTML = "";
  qs.forEach((q) => {
    const btn = document.createElement("button");
    btn.className   = "quick-btn";
    btn.textContent = q;
    btn.onclick     = () => submitQuestion(q);
    ql.appendChild(btn);
  });

  // Admin audit section
  if (role === "admin") $("auditSection").style.display = "block";

  // Render sessions list in sidebar
  renderSessionsList();

  // Load last session or create new one
  const sessions = loadAllSessions();
  if (sessions.length > 0) {
    loadSession(sessions[0].id);
  } else {
    startNewChat(true); // silent = true so we don't double-render
  }

  // Health check
  checkHealth();

  // Setup input auto-resize + keyboard shortcut
  setupInput();
}

// ── Sessions list render ───────────────────────────────────
function renderSessionsList() {
  const sessions = loadAllSessions();
  const list = $("chatSessionsList");
  list.innerHTML = "";

  if (sessions.length === 0) {
    list.innerHTML = '<p class="no-history-msg">No previous chats yet</p>';
    return;
  }

  sessions.forEach((s) => {
    const item = document.createElement("div");
    item.className = "session-item" + (s.id === currentSessionId ? " active" : "");
    item.dataset.id = s.id;

    const msgCount = s.messages ? s.messages.length : 0;
    const emoji = msgCount === 0 ? "💬" : "📊";

    item.innerHTML = `
      <div class="session-icon">${emoji}</div>
      <div class="session-info">
        <div class="session-title">${escHtml(s.title)}</div>
        <div class="session-time">${formatRelativeDate(s.updatedAt)} · ${Math.floor(msgCount / 2)} msg${Math.floor(msgCount / 2) !== 1 ? "s" : ""}</div>
      </div>
      <button class="session-delete" onclick="deleteSessionClick(event,'${s.id}')" title="Delete">
        <svg viewBox="0 0 16 16" fill="currentColor" width="11" height="11">
          <path d="M2 4h12M5 4V2h6v2M6 7v5M10 7v5M3 4l1 9h8l1-9"/>
        </svg>
      </button>`;

    item.addEventListener("click", () => loadSession(s.id));
    list.appendChild(item);
  });
}

function deleteSessionClick(e, id) {
  e.stopPropagation();
  deleteSession(id);
}

// ── Load a session ─────────────────────────────────────────
function loadSession(id) {
  const session = getSession(id);
  if (!session) return;

  currentSessionId = id;
  activeMessages   = [...(session.messages || [])];

  // Update title
  $("chatSessionTitle").textContent = session.title;

  // Render messages
  const container = $("chatMessages");
  container.innerHTML = "";

  if (activeMessages.length === 0) {
    renderWelcome();
  } else {
    activeMessages.forEach((m) => {
      if (m.role === "user") {
        renderUserMessage(m.text, m.time, false);
      } else {
        renderBotMessage(m.text, m.sql, m.columns, m.rows, m.time, false);
      }
    });
    scrollToBottom();
  }

  renderSessionsList();
}

// ── Start a new chat ───────────────────────────────────────
function startNewChat(silent = false) {
  const session    = createSession();
  currentSessionId = session.id;
  activeMessages   = [];

  $("chatSessionTitle").textContent = "New Chat";
  $("chatMessages").innerHTML = "";
  renderWelcome();
  renderSessionsList();

  if (!silent) $("chatInput").focus();
}

// ── Clear current chat ─────────────────────────────────────
function clearCurrentChat() {
  if (!currentSessionId) return;
  activeMessages = [];
  updateSessionMessages(currentSessionId, [], "New Chat");
  $("chatSessionTitle").textContent = "New Chat";
  $("chatMessages").innerHTML = "";
  renderWelcome();
  renderSessionsList();
}

// ── Welcome message ────────────────────────────────────────
function renderWelcome() {
  const { role, fullName } = currentUser;
  const greet = ["Sales","HR","Finance","Inventory","Management","Admin"].find(
    (r) => role && role.toLowerCase().includes(r.toLowerCase())
  ) || "Business";

  $("chatMessages").innerHTML = `
    <div class="welcome-card">
      <div class="welcome-icon">📊</div>
      <h3>Hello, ${escHtml((fullName || "User").split(" ")[0])}! 👋</h3>
      <p>
        I'm your <strong>${greet}</strong> analytics assistant.
        Ask me anything about your business data in plain English — I'll
        translate it to SQL, query the database, and explain the results.<br/><br/>
        Try one of the <strong>Quick Questions</strong> on the left, or type your own below.
      </p>
    </div>`;
}

// ── Health check ───────────────────────────────────────────
async function checkHealth() {
  const dot       = $("statusDot");
  const text      = $("statusText");
  const indicator = $("statusIndicator");
  try {
    const res  = await fetch("/health");
    const data = await res.json();
    const ok   = data.database === "ok" && data.ollama === "ok";
    dot.className        = "status-dot " + (ok ? "online" : "offline");
    indicator.className  = "status-indicator " + (ok ? "online" : "offline");
    text.textContent     = ok
      ? `${data.model} · Ready`
      : `DB:${data.database} | AI:${data.ollama}`;
    $("modelLabel").textContent = ok ? `${data.model} · On-Premise` : "Model offline";
  } catch {
    dot.className        = "status-dot offline";
    indicator.className  = "status-indicator offline";
    text.textContent     = "Server unreachable";
  }
}

// ── Chat input setup ───────────────────────────────────────
function setupInput() {
  const ta = $("chatInput");
  ta.addEventListener("input", () => {
    ta.style.height = "auto";
    ta.style.height = Math.min(ta.scrollHeight, 140) + "px";
  });
  ta.addEventListener("keydown", (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });
}

// ── Send message ───────────────────────────────────────────
function sendMessage() {
  const ta  = $("chatInput");
  const msg = ta.value.trim();
  if (!msg) return;
  ta.value        = "";
  ta.style.height = "auto";
  submitQuestion(msg);
}

async function submitQuestion(question) {
  // Ensure we have an active session
  if (!currentSessionId) startNewChat(true);

  // Remove welcome card if present
  const wc = $("chatMessages").querySelector(".welcome-card");
  if (wc) wc.remove();

  const now = new Date().toISOString();
  renderUserMessage(question, now, true);
  pushMessage({ role: "user", text: question, time: now });

  // Update session title from first message
  if (activeMessages.filter((m) => m.role === "user").length === 1) {
    $("chatSessionTitle").textContent =
      question.length > 42 ? question.slice(0, 42) + "…" : question;
  }

  const typingId = appendTyping();
  $("sendBtn").disabled = true;

  try {
    const res = await fetch("/chat", {
      method:  "POST",
      headers: {
        "Content-Type":  "application/json",
        "Authorization": "Bearer " + authToken,
      },
      body: JSON.stringify({ message: question }),
    });

    removeTyping(typingId);

    if (res.status === 401) {
      renderBotMessage("⚠️ Your session has expired. Please sign in again.", null, [], [], new Date().toISOString(), true);
      setTimeout(logout, 2000);
      return;
    }

    const data = await res.json();

    if (data.error && !data.reply) {
      const errMsg = "❌ " + (data.error || "An error occurred.");
      const t = new Date().toISOString();
      renderBotMessage(errMsg, null, [], [], t, true);
      pushMessage({ role: "bot", text: errMsg, sql: null, columns: [], rows: [], time: t });
      return;
    }

    const reply   = data.reply   || "Query executed.";
    const sql     = data.sql     || null;
    const columns = data.columns || [];
    const rows    = data.rows    || [];
    const t       = new Date().toISOString();

    renderBotMessage(reply, sql, columns, rows, t, true);
    pushMessage({ role: "bot", text: reply, sql, columns, rows, time: t });

  } catch {
    removeTyping(typingId);
    const errMsg = "❌ Cannot reach the server. Please check that Flask is running.";
    const t = new Date().toISOString();
    renderBotMessage(errMsg, null, [], [], t, true);
    pushMessage({ role: "bot", text: errMsg, sql: null, columns: [], rows: [], time: t });
  } finally {
    $("sendBtn").disabled = false;
  }
}

// ── Message renderers ──────────────────────────────────────
function renderUserMessage(text, timeIso, animate) {
  const messages = $("chatMessages");
  const row = document.createElement("div");
  row.className = "msg-row user" + (animate ? "" : " no-anim");
  row.innerHTML = `
    <div class="msg-content">
      <div class="msg-bubble">${escHtml(text)}</div>
      <span class="msg-time">${formatTime(timeIso)}</span>
    </div>
    <div class="msg-avatar user-av">${(currentUser.fullName || currentUser.username || "U")[0].toUpperCase()}</div>`;
  messages.appendChild(row);
  if (animate) scrollToBottom();
}

let typingCounter = 0;
const STATUS_STEPS = [
  { label: "Thinking…" },
  { label: "Generating SQL query…" },
  { label: "Executing on database…" },
  { label: "Preparing answer…" },
];

function appendTyping() {
  const id  = "typing-" + (++typingCounter);
  const row = document.createElement("div");
  row.className = "msg-row bot";
  row.id        = id;
  row.innerHTML = `
    <div class="msg-avatar bot-av">🤖</div>
    <div class="msg-content">
      <div class="exec-status" id="exec-${id}">
        <div class="exec-dots"><span></span><span></span><span></span></div>
        <span class="exec-label" id="label-${id}">Thinking…</span>
      </div>
    </div>`;
  $("chatMessages").appendChild(row);
  scrollToBottom();

  let step = 0;
  const interval = setInterval(() => {
    step = Math.min(step + 1, STATUS_STEPS.length - 1);
    const labelEl = document.getElementById(`label-${id}`);
    if (labelEl) {
      labelEl.style.opacity = "0";
      setTimeout(() => {
        if (labelEl) { labelEl.textContent = STATUS_STEPS[step].label; labelEl.style.opacity = "1"; }
      }, 150);
    }
    if (step >= STATUS_STEPS.length - 1) clearInterval(interval);
  }, 2400);

  row._statusInterval = interval;
  return id;
}

function removeTyping(id) {
  const el = document.getElementById(id);
  if (el) {
    if (el._statusInterval) clearInterval(el._statusInterval);
    el.remove();
  }
}

function renderBotMessage(text, sql, columns, rows, timeIso, animate) {
  const messages = $("chatMessages");
  const row = document.createElement("div");
  row.className = "msg-row bot" + (animate ? "" : " no-anim");

  const sqlId   = "sql-"   + Date.now() + Math.random().toString(36).slice(2, 6);
  const tableId = "tbl-"   + Date.now() + Math.random().toString(36).slice(2, 6);

  const hasSql  = sql && sql.trim().length > 0;
  const hasRows = columns && columns.length > 0 && rows && rows.length > 0;

  let sqlPanel  = "";
  let tableHtml = "";

  if (hasSql) {
    const rowLabel = hasRows
      ? ` · ${rows.length} row${rows.length !== 1 ? "s" : ""}`
      : " · no results";
    sqlPanel = `
      <button class="sql-toggle" onclick="toggleSql('${sqlId}','${tableId}',this)" id="btn-${sqlId}">
        <svg width="11" height="11" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd"/>
        </svg>
        <span class="sql-toggle-text">View SQL &amp; Results</span>
        <span class="sql-badge">${rowLabel}</span>
      </button>
      <div class="sql-expand-wrap hidden" id="${sqlId}">
        <div class="sql-expand-label">Generated SQL</div>
        <div class="sql-panel">${escHtml(sql)}</div>
      </div>`;
  }

  if (hasRows) {
    const headers  = columns.map((c) => `<th>${escHtml(c)}</th>`).join("");
    const bodyRows = rows.map((r) =>
      "<tr>" + r.map((v) =>
        `<td>${v !== null ? escHtml(String(v)) : '<em style="opacity:.4">NULL</em>'}</td>`
      ).join("") + "</tr>"
    ).join("");
    tableHtml = `
      <div class="result-table-extra hidden" id="${tableId}">
        <div class="sql-expand-label" style="margin-top:10px">Query Results</div>
        <div class="result-table-wrap">
          <table class="result-table">
            <thead><tr>${headers}</tr></thead>
            <tbody>${bodyRows}</tbody>
          </table>
        </div>
        <span class="row-count">${rows.length} row${rows.length !== 1 ? "s" : ""} returned</span>
      </div>`;
  }

  row.innerHTML = `
    <div class="msg-avatar bot-av">🤖</div>
    <div class="msg-content">
      <div class="msg-bubble">${formatReply(text)}</div>
      ${sqlPanel}
      ${tableHtml}
      <span class="msg-time">${formatTime(timeIso)}</span>
    </div>`;

  messages.appendChild(row);
  if (animate) scrollToBottom();
}

function toggleSql(panelId, tableId, btn) {
  const panel = document.getElementById(panelId);
  const tbl   = document.getElementById(tableId);
  const open  = !panel.classList.contains("hidden");
  panel.classList.toggle("hidden", open);
  if (tbl) tbl.classList.toggle("hidden", open);
  btn.classList.toggle("open", !open);
  const textEl = btn.querySelector(".sql-toggle-text");
  if (textEl) textEl.textContent = open ? "View SQL & Results" : "Hide SQL & Results";
}

// ── Audit log ──────────────────────────────────────────────
async function loadAudit() {
  if (!currentSessionId) startNewChat(true);
  const wc = $("chatMessages").querySelector(".welcome-card");
  if (wc) wc.remove();

  const now = new Date().toISOString();
  renderUserMessage("[Audit Log Request]", now, true);
  pushMessage({ role: "user", text: "[Audit Log Request]", time: now });

  const typingId = appendTyping();
  try {
    const res  = await fetch("/audit", {
      headers: { Authorization: "Bearer " + authToken },
    });
    removeTyping(typingId);
    const data = await res.json();
    if (!Array.isArray(data)) {
      const msg = data.error || "Error fetching audit log.";
      const t = new Date().toISOString();
      renderBotMessage(msg, null, [], [], t, true);
      pushMessage({ role: "bot", text: msg, sql: null, columns: [], rows: [], time: t });
      return;
    }
    const cols = ["LogID","Username","Role","Question","Status","Rows","Time"];
    const rows = data.map((r) => [
      r.LogID, r.Username, r.UserRole,
      r.Question.length > 60 ? r.Question.slice(0, 60) + "…" : r.Question,
      r.ExecutionStatus, r.RowsReturned, r.LoggedAt,
    ]);
    const msg = `Showing last ${data.length} audit entries.`;
    const t = new Date().toISOString();
    renderBotMessage(msg, null, cols, rows, t, true);
    pushMessage({ role: "bot", text: msg, sql: null, columns: cols, rows, time: t });
  } catch {
    removeTyping(typingId);
    const msg = "Failed to load audit log.";
    const t = new Date().toISOString();
    renderBotMessage(msg, null, [], [], t, true);
    pushMessage({ role: "bot", text: msg, sql: null, columns: [], rows: [], time: t });
  }
}

// ── Utilities ──────────────────────────────────────────────
function scrollToBottom() {
  const m = $("chatMessages");
  requestAnimationFrame(() => { m.scrollTop = m.scrollHeight; });
}

function escHtml(str) {
  return String(str)
    .replace(/&/g,"&amp;")
    .replace(/</g,"&lt;")
    .replace(/>/g,"&gt;")
    .replace(/"/g,"&quot;");
}

function formatReply(text) {
  return escHtml(text)
    .replace(/\*\*(.*?)\*\*/g, "<strong>$1</strong>")
    .replace(/\n/g, "<br/>");
}

function logout() {
  authToken        = null;
  currentUser      = {};
  currentSessionId = null;
  activeMessages   = [];
  sessionStorage.clear();
  $("chatMessages").innerHTML = "";
  $("chatSessionsList").innerHTML = '<p class="no-history-msg">No previous chats yet</p>';
  $("loginError").classList.add("hidden");
  $("usernameInput").value = "";
  $("passwordInput").value = "";
  showScreen("login");
}
