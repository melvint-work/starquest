# Step 5 — Verify the optimized image

Run through each check to confirm your image meets the North Pole Container Standard.

## Size comparison

```
docker images | grep gift-tracker
```{{exec}}

The optimized image should be under 200MB. The naive image was 1GB+.

## Non-root check

```
docker run --rm gift-tracker:optimized whoami
```{{exec}}

Should NOT return `root`. Then run the app and check `user_id`:

```
docker run -d --name opt-app -p 5000:5000 gift-tracker:optimized
sleep 2
curl http://localhost:5000/
docker stop opt-app && docker rm opt-app
```{{exec}}

`user_id` should be `1001` — not `0`.

## No secrets in history

```
docker history gift-tracker:optimized | grep -i env
docker inspect gift-tracker:optimized | grep -i api_key
```{{exec}}

No `API_KEY` should appear.

## HEALTHCHECK defined

```
docker inspect gift-tracker:optimized | grep -A6 Healthcheck
```{{exec}}

Should show your healthcheck command, not `null`.

## Lint with Hadolint

```
docker run --rm -v /root/gift-tracker/02-optimized-build/Dockerfile:/Dockerfile:ro \
  hadolint/hadolint hadolint /Dockerfile
```{{exec}}

Should pass with no warnings.

## Bonus: Scan with Trivy

```
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image --severity HIGH,CRITICAL gift-tracker:optimized
```{{exec}}

Compare the CVE count against `gift-tracker:naive`. The slim base + multi-stage build significantly reduces the attack surface.

---

> **Click "Check" to run the automated verification and complete the scenario.**
