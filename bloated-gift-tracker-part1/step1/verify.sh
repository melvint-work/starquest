#!/bin/bash
# Verify: naive image was built successfully
docker image inspect gift-tracker:naive &>/dev/null
