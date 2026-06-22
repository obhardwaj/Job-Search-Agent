# ── STAGE 1: SHARED BASE ──────────────────────────────────────────────────
# This layer handles things that every single service needs
FROM python:3.10-slim AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# ── STAGE 2: THE API GATEWAY RUNTIME ──────────────────────────────────────
FROM base AS api-runtime
CMD ["uvicorn", "api.app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# ── STAGE 3: THE RESUME STORE MCP RUNTIME ──────────────────────────────────
FROM base AS resume-store-runtime
CMD ["python", "mcp-servers/resume-store/main.py"]

# ── STAGE 4: THE TRACKER MCP RUNTIME ──────────────────────────────────────
FROM base AS tracker-runtime
CMD ["python", "mcp-servers/tracker/main.py"]