#!/bin/bash
# Verify: naive image was built AND user recorded an image size containing "GB"

docker image inspect gift-tracker:naive &>/dev/null || { echo "Image not found. Build it first."; exit 1; }

if [ ! -f /tmp/q1-size ]; then
  echo "No answer recorded. Run the image size command and enter the size when prompted."
  exit 1
fi

grep -qi "gb" /tmp/q1-size || { echo "Expected a size in GB (e.g. 1.14GB). Got: $(cat /tmp/q1-size)"; exit 1; }
