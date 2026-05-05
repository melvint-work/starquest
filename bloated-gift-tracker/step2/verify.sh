#!/bin/bash
# Verify: API_KEY is findable in the naive image history (confirms image exists with secret)
docker history gift-tracker:naive | grep -q "API_KEY"
