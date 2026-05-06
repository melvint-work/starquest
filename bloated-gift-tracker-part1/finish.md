# Part 1 Complete — Problems Identified!

You've diagnosed every violation baked into the naive Gift Tracker image.

## What you found

| # | Problem | Root Cause |
|---|---|---|
| 1 | Image over 1GB | `python:latest` base — no multi-stage build |
| 2 | Runs as root | No `USER` instruction in the Dockerfile |
| 3 | Hardcoded secret | `ENV API_KEY=northpole-secret-key-do-not-share` baked into a layer |
| 4 | Broken layer cache | `COPY . .` before `pip install` forces full reinstall on every code change |
| 5 | Secret files in image | No `.dockerignore` — `.env` and large files enter the build context |
| 6 | No HEALTHCHECK | Orchestrators cannot detect whether the app is actually ready |

## What's next

Head to **Part 2: Fix** to write a production-ready Dockerfile that eliminates every one of these problems and meets the North Pole Container Standard.
