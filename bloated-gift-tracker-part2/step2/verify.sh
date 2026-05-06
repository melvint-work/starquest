#!/bin/bash
# Final verification — checks all North Pole Container Standard requirements

IMAGE="gift-tracker:optimized"
PASS=0
FAIL=0

pass() { echo "PASS: $1"; ((PASS++)); }
fail() { echo "FAIL: $1"; ((FAIL++)); }

# 1. Image exists
if ! docker image inspect "$IMAGE" &>/dev/null; then
  echo "Image '$IMAGE' not found. Run: docker build -t gift-tracker:optimized ."
  exit 1
fi

# 2. Image size under 200MB
SIZE_BYTES=$(docker image inspect "$IMAGE" --format '{{.Size}}')
SIZE_MB=$((SIZE_BYTES / 1024 / 1024))
if [ "$SIZE_MB" -lt 200 ]; then
  pass "Image size is ${SIZE_MB}MB (under 200MB)"
else
  fail "Image size is ${SIZE_MB}MB — must be under 200MB"
fi

# 3. Not running as root
USER_OUT=$(docker run --rm "$IMAGE" whoami 2>/dev/null || echo "root")
if [ "$USER_OUT" != "root" ]; then
  pass "App runs as non-root: $USER_OUT"
else
  fail "App is running as root — add USER instruction"
fi

# 4. HEALTHCHECK defined
HEALTH=$(docker inspect "$IMAGE" --format '{{.Config.Healthcheck}}' 2>/dev/null)
if [ "$HEALTH" != "<nil>" ] && [ -n "$HEALTH" ]; then
  pass "HEALTHCHECK is defined"
else
  fail "No HEALTHCHECK found"
fi

# 5. No hardcoded API_KEY
if docker history "$IMAGE" | grep -q "API_KEY"; then
  fail "API_KEY found in image history — remove ENV API_KEY"
else
  pass "No hardcoded API_KEY in image"
fi

# 6. Multi-stage build (two FROM lines in Dockerfile)
FROM_COUNT=$(grep -c "^FROM" /root/gift-tracker/02-optimized-build/Dockerfile 2>/dev/null || echo 0)
if [ "$FROM_COUNT" -ge 2 ]; then
  pass "Multi-stage build detected ($FROM_COUNT FROM instructions)"
else
  fail "No multi-stage build — Dockerfile needs at least 2 FROM instructions"
fi

# 7. .dockerignore exists
if [ -f /root/gift-tracker/02-optimized-build/.dockerignore ]; then
  pass ".dockerignore is present"
else
  fail ".dockerignore is missing"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

[ "$FAIL" -eq 0 ]
