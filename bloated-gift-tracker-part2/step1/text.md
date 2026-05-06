# Step 1 — Fix the Dockerfile

Now write the production-ready Dockerfile. Navigate to the optimized build directory:

```
cd /root/gift-tracker/02-optimized-build
```{{exec}}

Open the Dockerfile in the editor and replace its contents. Your Dockerfile must satisfy all of these:

| Requirement | How |
|---|---|
| Final image under 200MB | Use `python:3.13-slim` as the runtime base |
| Multi-stage build | Two `FROM` instructions — builder and runtime |
| Layer caching | Copy `requirements.txt` before `app.py` |
| Non-root user | `USER` instruction with a non-zero UID |
| No hardcoded secrets | No `ENV API_KEY=...` |
| HEALTHCHECK | Use `python -c "import urllib.request; ..."` |
| EXPOSE | Document port 5000 |

## Reference solution structure

If you're stuck, here is the skeleton — fill in the gaps:

```dockerfile
# Stage 1: builder
FROM python:3.13-slim AS builder
USER 0
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# Stage 2: runtime
FROM python:3.13-slim
USER 0
WORKDIR /app
ENV PYTHONPATH=/app/install
COPY --chown=1001:0 --from=builder /install /app/install
COPY --chown=1001:0 app.py .
EXPOSE 5000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1
USER 1001:0
CMD ["python", "app.py"]
```

## Edit the file

```
nano /root/gift-tracker/02-optimized-build/Dockerfile
```{{exec}}

When done, build the optimized image:

```
docker build -t gift-tracker:optimized .
```{{exec}}

---

> **Click "Check" once the optimized image is built successfully.**
