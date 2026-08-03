# tools/

Everything that produces the launch demo video. Run in this order.

```bash
# 1. Record. Drives the live site and writes /tmp/larpin-4k/raw.webm
cd ~/dev/claude-code-video-toolkit/playwright && npx tsx scripts/flows/larpin.ts

# 2. Encode to 4K h264
~/dev/larpin/tools/encode_demo.sh /tmp/larpin-4k/raw.webm ~/Desktop

# 3. Prepend the branded opening frame
~/dev/larpin/tools/add_logo_card.sh ~/Desktop/larpin-demo-4k.mp4 ~/Desktop/larpin-demo-4k-logo.mp4
```

`record_demo_4k.ts` is a versioned copy of the toolkit flow so the repo carries
its own demo script. The toolkit copy at
`~/dev/claude-code-video-toolkit/playwright/scripts/flows/larpin.ts` is the one
that actually runs; keep them in sync when either changes.

## Why each step exists

**encode_demo.sh** also emits a 60fps motion-interpolated cut as a candidate. It
is usually the wrong choice: `minterpolate` smears text during scroll and took 28
minutes to produce 1MB. Playwright's recorder caps at ~25fps and CDP screencast
measured 3.7fps headless, so 4K/30 is the real ceiling. Smoothness comes from the
motion itself, every scroll, cursor move and zoom eased per frame with
requestAnimationFrame, not from inventing frames afterwards.

**add_logo_card.sh** exists because the capture opens on a blank white frame while
the page loads, and that frame is what X and LinkedIn use as the timeline
thumbnail. A launch video that thumbnails as nothing is a wasted upload. The
script crops the logo to its content box first, since `docs/media/logo.png`
carries enough of its own whitespace that scaling the full canvas leaves the mark
too small to read at timeline size.

**brand_card.html** is the source for the logo card artwork.

**record_demo.py** is the older 1080p recorder, kept for reference only.

## Recording conventions

Two things carry the look, both documented in the toolkit's
`playwright-recording` skill:

- Captions are chat bubbles in the Montrose Labs scheme (`#0c0c0c` on
  `#E91E63` accent), not lower thirds.
- Typing is the tightest framing in the video. The push-in lands before the first
  keystroke, anchored on the surrounding card rather than the input, because
  scaling around a field low in a short page throws half the frame away as empty
  background.

One trap worth knowing: the zoom scales `body`, and a transformed ancestor
becomes the containing block for `position: fixed`. The cursor, ring and caption
overlays therefore hang off `<html>`, not `<body>`, or they get dragged around
with the page and clicks stop landing while zoomed.
