# The Bloated Gift Tracker — Part 1: Diagnose

> **Points:** 100 &nbsp;|&nbsp; **Prerequisites:** Basic Docker/Dockerfile knowledge, understanding of container image layers. <br>
>
> **Learning Objectives:**
> Identify common Docker anti-patterns by hands-on inspection of a deliberately broken image.

---

## The Situation

The rogue elves have struck. They've sabotaged the **Gift Tracking Service** container build pipeline — a Flask API that logs every present destined for North Pole delivery.

The image builds and runs. But it violates every container best practice:

- Over **1GB** in size (standard requires under 200MB)
- Runs as **root** — a major security risk
- Has a **hardcoded secret** baked into the image layers permanently
- **Breaks layer caching** on every code change
- Copies **secret files** into the image because there's no `.dockerignore`
- No **HEALTHCHECK** — orchestrators can't tell if the app is actually ready

## Your Mission

Build the naive image and discover each problem firsthand. In Part 2 you will fix everything.

## What Already Exists

Your working directory is `/root/gift-tracker/`:

```
gift-tracker/
├── resources/
│   ├── .env                  ← Contains a fake secret (should NOT enter image)
│   └── heavy-artifact.zip    ← Large file (should NOT enter image)
└── 01-naive-build/
    ├── Dockerfile            ← The BAD Dockerfile — study it
    ├── app.py
    └── requirements.txt
```

> The environment is setting up.
> Please wait for **"START"** to load before starting. <br>
> Click on the **"Editor"** tab to access the files.
