#!/usr/bin/env bash
set -e

PROFILE_DIR="${WEB_AI_PROFILE_DIR:-$HOME/.cache/nvim-web-ai/chrome-profile}"
CDP_PORT="${WEB_AI_CDP_PORT:-9222}"

BROWSER=""
for cand in google-chrome google-chrome-stable chromium chromium-browser brave-browser microsoft-edge; do
  if command -v "$cand" >/dev/null 2>&1; then
    BROWSER="$cand"
    break
  fi
done
if [ -z "$BROWSER" ]; then
  echo "Chrome/Chromium/Brave/Edge not found in PATH" >&2
  exit 1
fi

mkdir -p "$PROFILE_DIR"
echo "Launching $BROWSER (port=$CDP_PORT, profile=$PROFILE_DIR)"
exec "$BROWSER" \
  --remote-debugging-port="$CDP_PORT" \
  --user-data-dir="$PROFILE_DIR" \
  --no-first-run \
  --no-default-browser-check \
  "$@"
