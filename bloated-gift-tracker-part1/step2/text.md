# Step 2 — Find the leaked secret

The naive Dockerfile contains this line:

```dockerfile
ENV API_KEY=northpole-secret-key-do-not-share
```

That secret is now **permanently baked** into the image layer. Even if you add a later layer that deletes it, the original layer still exists in the image history — anyone who pulls the image can extract it.

## Inspect the image history

```
docker history gift-tracker:naive
```{{exec}}

Look for the `ENV` line. The secret is visible right there in plain text.

## Inspect the image metadata directly

```
docker inspect gift-tracker:naive | grep -i api_key
```{{exec}}

The key is retrievable without even running a container.

## Why this matters

Even if you fix this in a future commit by removing the `ENV` line, the secret still lives in older image layers in any registry it was pushed to. The only safe fix is to rotate the secret and ensure it was never in the Dockerfile in the first place.

## The correct approach

Secrets must **never** go in `ENV` in a Dockerfile. They should be injected at runtime:

```bash
# Inject a single variable at runtime
docker run -e API_KEY=my-secret gift-tracker:optimized

# Or use an env file that is in .gitignore
docker run --env-file .env gift-tracker:optimized
```

---

> **Click "Check" to verify you've inspected the image history.**
