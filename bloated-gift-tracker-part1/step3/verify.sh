#!/bin/bash
# Verify: app.py restored to original (no "v2" string remaining)
grep -q "Gift Tracking Service" /root/gift-tracker/01-naive-build/app.py && \
! grep -q "Gift Tracking Service v2" /root/gift-tracker/01-naive-build/app.py
