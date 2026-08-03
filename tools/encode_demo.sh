#!/bin/bash
# Encode the raw 4K capture two ways so we can pick the better one.
#
#   1. clean   : native cadence, 30fps, no invented frames. Always safe.
#   2. smooth60: motion-interpolated to 60fps. Smoother pans, but interpolation can
#                smear text during scroll, so it is a candidate and not the default.
#
# Usage: tools/encode_demo.sh [raw.webm] [outdir]
set -e
SRC="${1:-/tmp/larpin-4k/raw.webm}"
OUT="${2:-$HOME/Desktop}"
[ -f "$SRC" ] || { echo "no raw capture at $SRC"; exit 1; }
mkdir -p "$OUT"

echo "[1/2] clean 30fps 4K ..."
ffmpeg -y -v error -i "$SRC" \
  -vf "fps=30" \
  -c:v libx264 -crf 17 -preset slow -pix_fmt yuv420p -movflags faststart \
  "$OUT/larpin-demo-4k.mp4"
echo "      -> $OUT/larpin-demo-4k.mp4"

echo "[2/2] interpolated 60fps 4K (slow) ..."
ffmpeg -y -v error -i "$SRC" \
  -vf "minterpolate=fps=60:mi_mode=mci:mc_mode=obmc:me_mode=bidir:me=epzs:vsbmc=0" \
  -c:v libx264 -crf 18 -preset veryfast -pix_fmt yuv420p -movflags faststart \
  "$OUT/larpin-demo-4k-60fps.mp4"
echo "      -> $OUT/larpin-demo-4k-60fps.mp4"

echo
for f in "$OUT/larpin-demo-4k.mp4" "$OUT/larpin-demo-4k-60fps.mp4"; do
  [ -f "$f" ] && ffprobe -v error -select_streams v:0 \
    -show_entries stream=width,height,r_frame_rate -show_entries format=duration,size \
    -of default=nw=1 "$f" | tr '\n' ' ' && echo "  <- $(basename "$f")"
done
