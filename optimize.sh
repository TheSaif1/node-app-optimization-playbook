#!/bin/bash
# optimize.sh - Chrome Helper Process Priority Adjustment
#
# Usage:
#   ./optimize.sh           Apply a mild priority boost to Chrome helper processes
#   ./optimize.sh --revert  Reset Chrome helper processes back to default priority (0)

NICE_VALUE=-5      # Mild priority boost. NOT -20 (that's system-critical tier and can starve the OS).
REVERT=false

if [[ "$1" == "--revert" ]]; then
  REVERT=true
  NICE_VALUE=0
fi

# Check we can actually use sudo non-interactively before doing anything
if ! sudo -n true 2>/dev/null; then
  echo "This script needs sudo access to renice processes."
  echo "Run 'sudo -v' first to authenticate, then re-run this script."
  exit 1
fi

PIDS=$(pgrep -f "Google Chrome Helper")

if [[ -z "$PIDS" ]]; then
  echo "No Chrome helper processes found. Is Chrome running?"
  exit 0
fi

echo "Found $(echo "$PIDS" | wc -l | tr -d ' ') Chrome helper process(es)."
$REVERT && echo "Reverting to default priority (0)..." || echo "Setting priority to $NICE_VALUE..."

SUCCESS=0
FAIL=0

for pid in $PIDS; do
  if sudo renice "$NICE_VALUE" -p "$pid" >/dev/null 2>&1; then
    echo "  PID $pid -> priority $NICE_VALUE (OK)"
    ((SUCCESS++))
  else
    echo "  PID $pid -> FAILED"
    ((FAIL++))
  fi
done

echo ""
echo "Done. $SUCCESS succeeded, $FAIL failed."
