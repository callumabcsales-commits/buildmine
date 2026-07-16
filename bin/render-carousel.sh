#!/bin/bash
# render-carousel.sh <dir> — screenshot every slide-*.html in <dir> to a matching .png (1080x1350, IG 4:5)
# Requires Chrome or Chromium. Used by the buildmine-carousel skill.
set -euo pipefail
DIR="${1:?usage: render-carousel.sh <carousel-dir>}"

find_chrome() {
  local candidates=(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
    "$(command -v google-chrome || true)"
    "$(command -v google-chrome-stable || true)"
    "$(command -v chromium || true)"
    "$(command -v chromium-browser || true)"
  )
  for c in "${candidates[@]}"; do
    [ -n "$c" ] && [ -x "$c" ] && { echo "$c"; return 0; }
  done
  return 1
}

CHROME="$(find_chrome)" || { echo "error: Chrome/Chromium not found — install one to render carousels" >&2; exit 1; }

count=0
shopt -s nullglob
for f in "$DIR"/slide-*.html; do
  out="${f%.html}.png"
  "$CHROME" --headless --disable-gpu --hide-scrollbars \
    --window-size=1080,1350 --force-device-scale-factor=1 \
    --screenshot="$out" "file://$f" 2>/dev/null
  count=$((count+1))
done
[ "$count" -gt 0 ] || { echo "no slide-*.html files in $DIR" >&2; exit 1; }
echo "rendered $count slides in $DIR"
