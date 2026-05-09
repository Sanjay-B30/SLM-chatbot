import os
from dotenv import load_dotenv

load_dotenv(override=True)

# ── Database ──────────────────────────────────────────────
DB_HOST     = os.getenv("DB_HOST",     "localhost")
DB_PORT     = int(os.getenv("DB_PORT", "3306"))
DB_USER     = os.getenv("DB_USER",     "root")
DB_PASSWORD = os.getenv("DB_PASSWORD", "sanjay05")
DB_NAME     = os.getenv("DB_NAME",     "chatbot_db")

# ── Ollama / Model ────────────────────────────────────────
OLLAMA_URL   = os.getenv("OLLAMA_URL",   "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "gemma3:1b")

# ── Security ──────────────────────────────────────────────
JWT_SECRET      = os.getenv("JWT_SECRET",      "chatbot_jwt_secret_key_change_in_prod")
JWT_EXPIRY_MINS = int(os.getenv("JWT_EXPIRY_MINS", "480"))   # 8 hours

# ── App ───────────────────────────────────────────────────
DEBUG = os.getenv("FLASK_DEBUG", "True").lower() == "true"
PORT  = int(os.getenv("PORT", "5000"))
