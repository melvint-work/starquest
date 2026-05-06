#!/bin/bash
# Runs in the background while the intro page is shown.
# Sets up all scenario files so learners can start immediately.

set -e

mkdir -p /root/gift-tracker/01-naive-build
mkdir -p /root/gift-tracker/resources

# ── app.py ────────────────────────────────────────────────────────────────────
cat > /root/gift-tracker/app.py << 'APPEOF'
import os
import socket
from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "v1.0.0")
TEAM = os.getenv("TEAM", "North Pole DevOps")

@app.route("/")
def index():
    return jsonify({
        "service": "Gift Tracking Service",
        "version": APP_VERSION,
        "team": TEAM,
        "hostname": socket.gethostname(),
        "user_id": os.getuid(),
    })

@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.route("/gifts")
def gifts():
    return jsonify([
        {"id": 1, "recipient": "Alice", "item": "Toy Train", "status": "pending"},
        {"id": 2, "recipient": "Bob",   "item": "Book",      "status": "delivered"},
        {"id": 3, "recipient": "Carol", "item": "Puzzle",    "status": "pending"},
    ])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
APPEOF

cp /root/gift-tracker/app.py /root/gift-tracker/01-naive-build/app.py

# ── requirements.txt ──────────────────────────────────────────────────────────
echo "flask==3.0.3" > /root/gift-tracker/01-naive-build/requirements.txt

# ── Teaching resources (.env and heavy file) ──────────────────────────────────
echo "DB_PASSWORD=supersecret123" > /root/gift-tracker/resources/.env
dd if=/dev/urandom bs=1M count=5 2>/dev/null > /root/gift-tracker/resources/heavy-artifact.zip

# ── 01-naive-build/Dockerfile (the BAD one) ───────────────────────────────────
cat > /root/gift-tracker/01-naive-build/Dockerfile << 'NAIVEEOF'
FROM python:latest

WORKDIR /app

COPY . .

ENV API_KEY=northpole-secret-key-do-not-share

RUN pip install -r requirements.txt

CMD ["python", "app.py"]
NAIVEEOF

# Signal that setup is complete
touch /tmp/setup-finished
