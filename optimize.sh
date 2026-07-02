#!/bin/bash
# optimize.sh - High-Performance Thread Priority Override

echo "Elevating all running Chromium helper and canvas engine threads..."

# Automatically captures all active Google Chrome process IDs and escalates them to the absolute maximum scheduling priority (-20)
pgrep -f "Google Chrome" | xargs -I {} sudo renice -20 -p {} 2>/dev/null

echo "System Optimization Complete. Maximum scheduling priority assigned."
