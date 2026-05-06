# The Bloated Gift Tracker — Part 2: Fix

> **Points:** 100 &nbsp;|&nbsp; **Prerequisites:** Part 1 of this scenario, or familiarity with Docker image anti-patterns. <br>
>
> **Learning Objectives:**
> Write a production-ready Dockerfile that implements optimization and security best practices.

---

## The Situation

In Part 1, you diagnosed six violations in the naive Gift Tracker image:

| # | Problem |
|---|---|
| 1 | Image over 1GB — `python:latest` with no multi-stage build |
| 2 | Runs as root — no `USER` instruction |
| 3 | Hardcoded secret — `ENV API_KEY=...` baked into a layer |
| 4 | Broken layer cache — `COPY . .` before `pip install` |
| 5 | No `.dockerignore` — secrets and large files enter the image |
| 6 | No `HEALTHCHECK` — orchestrators can't detect readiness |

## Your Mission

Fix every one of these problems by writing a production-ready Dockerfile in `02-optimized-build/`.

## What Already Exists

Your working directory is `/root/gift-tracker/`:

```
gift-tracker/
├── 01-naive-build/           ← Already built as gift-tracker:naive for comparison
└── 02-optimized-build/
    ├── Dockerfile            ← YOUR TASK: write this
    ├── .dockerignore         ← Already provided
    ├── app.py
    └── requirements.txt
```

> The environment is setting up.
> Please wait for **"START"** to load before starting. <br>
> Click on the **"Editor"** tab to access the files.
