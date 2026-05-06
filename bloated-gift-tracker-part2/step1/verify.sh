#!/bin/bash
# Verify: optimized image was built successfully
docker image inspect gift-tracker:optimized &>/dev/null
