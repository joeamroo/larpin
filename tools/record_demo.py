"""Record the cursor-choreographed LarpIn demo for social posts.

Recipe (proven on the km launch): 1920x1080 capture at device_scale_factor 2,
fake cursor + gold ripple, narrated callout bubbles, CSS-scale zooms with the
zoom grammar (zoom onto typing while it types, partial ease-back to show the
result, full reset before touching anything near a viewport edge), an in-page
end card, then a 4K60 minterpolate encode with a logo-first intro clip.

    .venv/bin/python tools/record_demo.py   # writes exports/capture path

Encoding happens separately (see docs or the launch session notes).
"""
from __future__ import annotations

import time
import urllib.request
from pathlib import Path

from playwright.sync_api import sync_playwright

BASE = "https://larpin.io"
OUT_DIR = Path(__file__).resolve().parent.parent / "exports"
VIDEO_DIR = OUT_DIR / "demo-video-raw"

HELPERS_JS = """
() => {
  if (document.getElementById('__cursor')) return;
  const c = document.createElement('div');
  c.id = '__cursor';
  c.innerHTML = `<svg width="34" height="34" viewBox="0 0 24 24">
    <path d="M5 3 L19 12 L12 13.5 L9.5 20 Z" fill="#fff" stroke="#000" stroke-width="1.4"/></svg>`;
  Object.assign(c.style, {position:'fixed', left:'960px', top:'520px', zIndex: 2147483647,
    pointerEvents:'none', transition:'left 0.7s cubic-bezier(.25,.6,.3,1), top 0.7s cubic-bezier(.25,.6,.3,1)',
    filter:'drop-shadow(0 2px 6px rgba(0,0,0,.55))'});
  document.body.appendChild(c);
  window.__moveCursor = (x, y, ms) => {
    c.style.transitionDuration = ms + 'ms, ' + ms + 'ms';
    c.style.left = x + 'px'; c.style.top = y + 'px';
  };
  window.__ripple = (x, y) => {
    const r = document.createElement('div');
    Object.assign(r.style, {position:'fixed', left:(x-5)+'px', top:(y-5)+'px', width:'10px',
      height:'10px', borderRadius:'50%', border:'3px solid #e3b04b', zIndex:2147483646,
      pointerEvents:'none', opacity:'0.95', transition:'all .5s ease-out'});
    document.body.appendChild(r);
    requestAnimationFrame(() => { r.style.transform='scale(5)'; r.style.opacity='0'; });
    setTimeout(() => r.remove(), 600);
  };
  window.__bubble = (html, x, y) => {
    window.__hideBubble();
    const b = document.createElement('div');
    b.id = '__bubble';
    b.innerHTML = html;
    Object.assign(b.style, {position:'fixed', left:x+'px', top:y+'px', maxWidth:'560px',
      background:'#1c2733', color:'#fff', padding:'20px 26px', borderRadius:'14px',
      borderLeft:'6px solid #e3b04b', fontSize:'26px', lineHeight:'1.35',
      fontFamily:'-apple-system, system-ui, sans-serif', zIndex:2147483645,
      boxShadow:'0 12px 40px rgba(0,0,0,.35)', opacity:'0',
      transform:'scale(.85)', transition:'opacity .3s ease-out, transform .3s cubic-bezier(.2,.8,.3,1.15)'});
    document.body.appendChild(b);
    requestAnimationFrame(() => { b.style.opacity = '1'; b.style.transform = 'scale(1)'; });
  };
  window.__hideBubble = () => {
    const b = document.getElementById('__bubble');
    if (b) { b.style.opacity = '0'; setTimeout(() => b.remove(), 250); }
  };
  document.body.style.transition = 'transform 0.65s cubic-bezier(.4,.05,.2,1)';
  window.__zoom = (scale, ox, oy) => {
    document.body.style.transformOrigin = ox + 'px ' + oy + 'px';
    document.body.style.transform = scale === 1 ? 'none' : 'scale(' + scale + ')';
  };
  window.__endCard = () => {
    const e = document.createElement('div');
    e.innerHTML = `
      <div style="display:flex;align-items:center">
        <span style="font-size:150px;font-weight:700;color:#0a66c2;letter-spacing:-0.045em;line-height:1;margin-right:10px;position:relative;top:-5px">Larp</span>
        <span style="width:180px;height:180px;border-radius:22px;background:#0a66c2;color:#fff;font-size:112px;font-weight:700;letter-spacing:-0.045em;display:flex;align-items:center;justify-content:center;padding-top:6px;box-sizing:border-box">in</span>
      </div>
      <p style="margin-top:48px;font-size:42px;color:rgba(25,25,25,.72);font-weight:500">LinkedIn, but everyone admits they're larping.</p>
      <p style="margin-top:22px;font-size:36px;color:#0a66c2;font-weight:700">larpin.io</p>`;
    Object.assign(e.style, {position:'fixed', inset:'0', background:'#f4f2ee', zIndex:2147483647,
      display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center',
      fontFamily:'-apple-system, system-ui, sans-serif', opacity:'0', transition:'opacity .6s ease-out'});
    document.body.appendChild(e);
    requestAnimationFrame(() => { e.style.opacity = '1'; });
  };
}
"""


class Director:
    def __init__(self, page):
        self.page = page
        self.install()

    def install(self):
        self.page.evaluate(HELPERS_JS)

    def pause(self, seconds: float):
        time.sleep(seconds)

    def glide(self, locator, ms=700):
        box = locator.bounding_box()
        x, y = box["x"] + box["width"] / 2, box["y"] + box["height"] / 2
        self.page.evaluate("([x,y,ms]) => window.__moveCursor(x,y,ms)", [x, y, ms])
        self.pause(ms / 1000 + 0.15)
        return x, y

    def click(self, locator, ms=700, settle=0.7):
        x, y = self.glide(locator, ms)
        self.page.evaluate("([x,y]) => window.__ripple(x,y)", [x, y])
        self.pause(0.18)
        self.page.mouse.click(x, y)
        self.pause(settle)
        self.install()
        return x, y

    def bubble(self, html, x, y, hold=2.0):
        self.page.evaluate("([h,x,y]) => window.__bubble(h,x,y)", [html, x, y])
        self.pause(hold)

    def hide_bubble(self):
        self.page.evaluate("() => window.__hideBubble()")
        self.pause(0.3)

    def zoom(self, scale, x, y, hold=1.4):
        self.page.evaluate("([s,x,y]) => window.__zoom(s,x,y)", [scale, x, y])
        self.pause(0.7 + hold)

    def unzoom(self, hold=0.4):
        self.page.evaluate("() => window.__zoom(1, 0, 0)")
        self.pause(0.7 + hold)


def main() -> None:
    VIDEO_DIR.mkdir(parents=True, exist_ok=True)
    for path in ["/", "/jobs", "/premium", "/?sort=new"]:
        try:
            urllib.request.urlopen(BASE + path, timeout=30).read()
        except OSError:
            pass

    with sync_playwright() as pw:
        browser = pw.chromium.launch()
        ctx = browser.new_context(
            viewport={"width": 1920, "height": 1080},
            device_scale_factor=2,
            record_video_dir=str(VIDEO_DIR),
            record_video_size={"width": 1920, "height": 1080},
        )
        ctx.add_init_script("try { window.localStorage.setItem('larpin_welcomed', '1') } catch {}")
        page = ctx.new_page()
        page.goto(BASE, wait_until="networkidle")
        page.wait_for_timeout(1200)
        d = Director(page)

        # Intro bubble
        d.bubble("<b>LarpIn</b>: LinkedIn, but <b>everyone admits they're larping</b>. No signup. You already have a fake persona.", 660, 430, hold=3.2)
        d.hide_bubble()

        # Scene 1: Larp Level chip on the first post
        chip = page.locator("article >> text=/Larp Lv\\./").first
        box = chip.bounding_box()
        d.bubble("Every post gets a <b>Larp Level</b>, scored on <b>buzzword density</b> and 4 AM references.", box["x"] - 600, box["y"] + 50, hold=1.6)
        d.glide(chip, ms=650)
        d.zoom(1.6, box["x"] + 40, box["y"], hold=1.7)
        d.unzoom(0.2)
        d.hide_bubble()

        # Scene 2: react with Grindset
        react = page.locator("article").first.get_by_role("button", name="React")
        rbox = react.bounding_box()
        d.bubble("React like a professional: <b>Grindset</b>, <b>Cap</b>, or <b>Crying at the Gym</b>.", rbox["x"] + 120, rbox["y"] - 150, hold=1.4)
        d.click(react, ms=650)
        grindset = page.locator("article").first.get_by_role("button", name="Grindset").first
        gbox = grindset.bounding_box()
        d.zoom(1.45, gbox["x"], gbox["y"], hold=0.2)
        d.click(grindset, ms=600, settle=0.9)
        d.zoom(1.15, gbox["x"], gbox["y"], hold=0.8)
        d.unzoom(0.2)
        d.hide_bubble()

        # Scene 3: write a larp, enhance it, post it (composer is at the top: origin y=0)
        page.evaluate("window.scrollTo({top: 0, behavior: 'smooth'})")
        d.pause(0.9)
        ta = page.locator('textarea[name="post[body]"]')
        d.click(ta, ms=700, settle=0.3)
        tbox = ta.bounding_box()
        d.bubble("Type something honest. Then make it <b>40% more insufferable</b>.", tbox["x"] + 620, tbox["y"] + 130, hold=0.1)
        d.zoom(1.6, tbox["x"] + tbox["width"] / 2, 0, hold=0.1)
        page.keyboard.type("i ate a sandwich at my desk today", delay=45)
        d.pause(0.5)
        enhance = page.get_by_role("button", name="Enhance").first
        d.click(enhance, ms=600, settle=2.4)
        d.zoom(1.15, tbox["x"] + tbox["width"] / 2, 0, hold=1.6)
        d.unzoom(0.2)
        d.hide_bubble()
        post_btn = page.locator('input[type="submit"][value="Post"]')
        d.click(post_btn, ms=650, settle=1.6)
        d.install()

        # Scene 4: hype squad on our fresh post
        page.get_by_role("link", name="Recent").click()
        page.wait_for_load_state("networkidle")
        d.install()
        d.pause(0.7)
        hype = page.get_by_role("button", name="Hype squad").first
        hbox = hype.bounding_box()
        d.bubble("Post flopping? Summon a <b>Hype Squad</b> of bots who believe in you (contractually).", hbox["x"] - 300, hbox["y"] - 170, hold=1.5)
        d.click(hype, ms=700, settle=1.6)
        d.install()
        comment_btn = page.locator("article").first.get_by_role("button", name="Comment")
        d.click(comment_btn, ms=600, settle=0.8)
        comments = page.locator('article >> css=[id^="comments_post_"]').first
        cbox = comments.bounding_box()
        if cbox:
            d.zoom(1.35, cbox["x"] + cbox["width"] / 2, cbox["y"], hold=2.2)
            d.unzoom(0.2)
        d.hide_bubble()

        # Scene 5: jobs board, instant rejection (fresh page: reset zoom first)
        page.goto(BASE + "/jobs", wait_until="networkidle")
        d.install()
        d.pause(0.8)
        apply_btn = page.get_by_role("button", name="Easy Apply").first
        abox = apply_btn.bounding_box()
        d.bubble("The jobs board: <b>Easy Apply</b> rejects you <b>instantly</b>. Just like real life, but faster.", abox["x"] - 640, abox["y"] + 60, hold=1.6)
        d.click(apply_btn, ms=700, settle=1.0)
        d.install()
        d.zoom(1.5, 960, 0, hold=2.0)  # rejection flash is top-center: origin y=0
        d.unzoom(0.2)
        d.hide_bubble()

        # Scene 6: premium
        page.goto(BASE + "/premium", wait_until="networkidle")
        d.install()
        d.pause(0.8)
        d.bubble("<b>Premium</b>: $0/month, billed never. The gold badge does <b>nothing</b>. Search is gated behind it anyway.", 620, 780, hold=2.2)
        d.zoom(1.3, 960, 300, hold=2.0)
        d.unzoom(0.2)
        d.hide_bubble()

        # End card
        page.evaluate("() => window.__endCard()")
        d.pause(3.4)

        ctx.close()
        video_path = page.video.path()
        browser.close()

    print(f"raw capture: {video_path}")


if __name__ == "__main__":
    main()
