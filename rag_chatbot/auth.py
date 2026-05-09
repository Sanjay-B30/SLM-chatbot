import jwt
import datetime
from functools import wraps
from flask import request, jsonify
from config import JWT_SECRET, JWT_EXPIRY_MINS


def generate_token(user_id: int, username: str, role: str, region: str = None, dept_id: int = None) -> str:
    """Generate a JWT token for a successfully authenticated user."""
    payload = {
        "user_id":  user_id,
        "username": username,
        "role":     role,
        "region":   region,
        "dept_id":  dept_id,
        "exp":      datetime.datetime.utcnow() + datetime.timedelta(minutes=JWT_EXPIRY_MINS),
        "iat":      datetime.datetime.utcnow(),
    }
    return jwt.encode(payload, JWT_SECRET, algorithm="HS256")


def decode_token(token: str) -> dict:
    """Decode and validate a JWT token. Raises jwt.ExpiredSignatureError or jwt.InvalidTokenError."""
    return jwt.decode(token, JWT_SECRET, algorithms=["HS256"])


def login_required(f):
    """Decorator: protects a route by requiring a valid Bearer JWT token."""
    @wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            return jsonify({"error": "Missing or invalid Authorization header"}), 401

        token = auth_header.split(" ", 1)[1]
        try:
            payload = decode_token(token)
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Session expired. Please log in again."}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Invalid token. Please log in again."}), 401

        # Attach decoded payload to request so routes can read it
        request.current_user = payload
        return f(*args, **kwargs)

    return decorated
