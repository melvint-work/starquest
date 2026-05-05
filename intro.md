# The Bloated Gift Tracker

**Points:** 200 &nbsp;|&nbsp; **Prerequisites:** Basic Docker/Dockerfile knowledge, understanding of container image layers

**Learning Objectives:** Multi-stage builds · layer caching · non-root users · `.dockerignore` · `HEALTHCHECK` · image pinning · no hardcoded secrets

---

## The Situation

The rogue elves have struck again. This time they've sabotaged the **Gift Tracking Service** container build pipeline — a Flask API that logs every present destined for North Pole delivery.

The image builds and runs. But it violates every container best practice:

- Over **1GB** in size (standard requires under 200MB)
- Runs as **root** — a major security risk
- Has a **hardcoded secret** baked into the image layers permanently
- **Breaks layer caching** on every code change
- Copies **secret files** into the image because there's no `.dockerignore`
- No **HEALTHCHECK** — orchestrators can't tell if the app is actually ready

## Your Mission

1. Build the naive image and discover each problem firsthand
2. Fix the Dockerfile so it meets the **North Pole Container Standard**
3. Verify your fix with the automated checks

## What Already Exists

Your working directory is `/root/gift-tracker/`:

```
gift-tracker/
├── resources/
│   ├── .env                  ← Contains a fake secret (should NOT enter image)
│   └── heavy-artifact.zip    ← Large file (should NOT enter image)
├── 01-naive-build/
│   ├── Dockerfile            ← The BAD Dockerfile — study it
│   ├── app.py
│   └── requirements.txt
└── 02-optimized-build/
    ├── Dockerfile            ← YOUR TASK: fix this
    ├── .dockerignore         ← Already provided
    ├── app.py
    └── requirements.txt
```

> The environment is setting up. Please wait for **"You can now begin!"** before starting.
