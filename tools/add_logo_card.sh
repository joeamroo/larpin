#!/bin/bash
# Prepends a branded logo card to the demo video.
#
# The reason this exists: the raw capture opens on a blank white frame while the
# page loads, and that frame is what X and LinkedIn use as the timeline
# thumbnail. A launch video that thumbnails as nothing is a wasted upload.
#
# The card holds for ~1.65s and fades into the demo over 0.25s. The logo is
# cropped to its content box first, because docs/media/logo.png carries a lot of
# its own whitespace and scaling the whole canvas leaves the mark too small to
# read at timeline size.
#
# Usage: tools/add_logo_card.sh [in.mp4] [out.mp4]
set -e
SRC="${1:-$HOME/Desktop/larpin-demo-4k.mp4}"
OUT="${2:-$HOME/Desktop/larpin-demo-4k-logo.mp4}"
LOGO="$(cd "$(dirname "$0")/.." && pwd)/docs/media/logo.png"
BG="0xF4F2EE"   # the logo's own background, sampled

[ -f "$SRC" ]  || { echo "no source video at $SRC"; exit 1; }
[ -f "$LOGO" ] || { echo "no logo at $LOGO"; exit 1; }

echo "prepending logo card to $(basename "$SRC") ..."
ffmpeg -y -v error \
  -loop 1 -t 1.9 -i "$LOGO" \
  -i "$SRC" \
  -filter_complex "\
    color=c=$BG:s=3840x2160:r=30:d=1.9,setsar=1[bg]; \
    [0:v]crop=1260:460:570:390,scale=2400:-2[lg]; \
    [bg][lg]overlay=(W-w)/2:(H-h)/2:shortest=1,\
      fade=t=out:st=1.65:d=0.25:color=$BG,fps=30,setsar=1,format=yuv420p[card]; \
    [1:v]scale=3840:2160,fps=30,setsar=1,format=yuv420p[main]; \
    [card][main]concat=n=2:v=1:a=0[out]" \
  -map "[out]" -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -movflags faststart \
  "$OUT"

echo "-> $OUT"
ffprobe -v error -select_streams v:0 \
  -show_entries stream=width,height,r_frame_rate -show_entries format=duration,size \
  -of default=nw=1 "$OUT"
