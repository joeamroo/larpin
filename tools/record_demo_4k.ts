/**
 * LarpIn demo, 4K (3840x2160), smooth motion.
 *
 * True 2x rendering: 1920x1080 CSS viewport with deviceScaleFactor 2, recorded at
 * 3840x2160. A real 4K capture, not an upscale.
 *
 * NOTE: every page.evaluate here passes a STRING, never a TS function. tsx/esbuild
 * injects a `__name` helper into named functions, and that helper does not exist in
 * the page context, so serialized function bodies die with "__name is not defined".
 * Strings pass through untouched.
 *
 * Playwright's recorder emits ~25fps and that is not configurable, so smoothness comes
 * from the motion itself: every scroll, cursor move, and zoom is eased per frame via
 * requestAnimationFrame rather than stepped.
 *
 * Scene order matches the launch copy, which leads on the global feed and DMs.
 *
 * Run:  cd playwright && npx tsx scripts/flows/larpin.ts
 */
import { chromium, Browser, BrowserContext, Page } from 'playwright';
import * as fs from 'fs';
import * as path from 'path';

const BASE = process.env.LARPIN_URL || 'https://larpin.io';
const TMP = '/tmp/larpin-4k';

// Montrose Labs scheme, lifted from montroselabs.ai's own CSS variables:
//   bg #0c0c0c   text #ffffff   secondary #a1a1aa   border #333333   accent #E91E63
//   (the light theme's cream is #fdf5DE, used here for the ring so it reads on dark)
const ML = {
  bg: '#0c0c0c',
  text: '#ffffff',
  dim: '#a1a1aa',
  border: '#333333',
  accent: '#E91E63',
  cream: '#fdf5DE',
};

const CSS = `
  *{scrollbar-width:none!important}
  ::-webkit-scrollbar{display:none!important}
  #lk-cursor{position:fixed;left:0;top:0;width:32px;height:32px;z-index:2147483647;
    pointer-events:none;will-change:transform;filter:drop-shadow(0 3px 7px rgba(0,0,0,.4))}
  #lk-ring{position:fixed;left:0;top:0;width:16px;height:16px;border-radius:50%;
    border:3px solid ${ML.accent};z-index:2147483646;pointer-events:none;opacity:0}
  #lk-ring.go{animation:lkring .6s cubic-bezier(.2,.7,.3,1)}
  @keyframes lkring{0%{opacity:.95;transform:translate(-50%,-50%) scale(.25)}
    100%{opacity:0;transform:translate(-50%,-50%) scale(3.4)}}

  /* Caption bubbles: a chat bubble, not a lower third. Rounded hard, tail on the
     bottom-left, and an accent dot so the eye lands on it before the words. */
  #lk-cap{position:fixed;left:82px;bottom:96px;z-index:2147483645;
    background:${ML.bg};color:${ML.text};padding:20px 30px 21px 30px;
    border:1px solid ${ML.border};border-radius:30px 30px 30px 8px;
    font:600 27px/1.36 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial;
    letter-spacing:-.011em;max-width:820px;
    opacity:0;transform:translateY(20px) scale(.94);transform-origin:0 100%;
    transition:opacity .34s cubic-bezier(.2,.7,.3,1),transform .42s cubic-bezier(.34,1.3,.5,1);
    box-shadow:0 22px 54px rgba(0,0,0,.34)}
  #lk-cap.on{opacity:1;transform:translateY(0) scale(1)}
  /* The tail. Two stacked triangles so the 1px border reads on the diagonal too. */
  #lk-cap::after{content:'';position:absolute;left:-1px;bottom:-17px;
    border-width:18px 0 0 20px;border-style:solid;
    border-color:${ML.border} transparent transparent transparent}
  #lk-cap::before{content:'';position:absolute;left:0;bottom:-15px;
    border-width:16px 0 0 18px;border-style:solid;
    border-color:${ML.bg} transparent transparent transparent;z-index:1}
  /* Accent dot, drawn as a leading inline marker on the text node's first line. */
  #lk-cap .lk-dot{display:inline-block;width:11px;height:11px;border-radius:50%;
    background:${ML.accent};margin-right:14px;vertical-align:middle;
    position:relative;top:-2px;box-shadow:0 0 0 5px rgba(233,30,99,.16)}
`;

// Installed as a plain string: no transpiler helpers reach the page.
const INSTALL = `(function(){
  if (document.getElementById('lk-cursor') && document.getElementById('lk-ring')) return 'already';
  var old = document.getElementById('lk-cursor'); if (old) old.remove();

  // Overlays hang off <html>, NOT <body>. The zoom scales body, and a transformed
  // ancestor becomes the containing block for position:fixed, which would drag the
  // cursor, ring and caption around with the page. Outside body they stay pinned to
  // the viewport, so cursor coordinates keep matching Playwright's click coordinates
  // even at 1.8x. This is what makes it safe to click while zoomed in.
  var root = document.documentElement;
  var c = document.createElement('div');
  c.id = 'lk-cursor';
  c.innerHTML = '<svg viewBox="0 0 24 24" width="32" height="32"><path d="M5 3 L19 12 L12 13.5 L9.5 20 Z" fill="#fff" stroke="#0b0b0b" stroke-width="1.5"/></svg>';
  root.appendChild(c);
  var r = document.createElement('div'); r.id = 'lk-ring'; root.appendChild(r);
  var cap = document.createElement('div'); cap.id = 'lk-cap'; root.appendChild(cap);
  window.__lk = { x: 960, y: 560 };
  c.style.transform = 'translate(960px,560px)';

  window.__lkMove = function (tx, ty, ms) {
    return new Promise(function (done) {
      var s = performance.now(), sx = window.__lk.x, sy = window.__lk.y;
      function step(now) {
        var t = Math.min(1, (now - s) / ms), e = 1 - Math.pow(1 - t, 3);
        var x = sx + (tx - sx) * e, y = sy + (ty - sy) * e;
        c.style.transform = 'translate(' + x + 'px,' + y + 'px)';
        window.__lk = { x: x, y: y };
        if (t < 1) requestAnimationFrame(step); else done(1);
      }
      requestAnimationFrame(step);
    });
  };

  window.__lkScroll = function (to, ms) {
    return new Promise(function (done) {
      var s = performance.now(), from = window.scrollY, d = to - from;
      function step(now) {
        var t = Math.min(1, (now - s) / ms);
        var e = t < 0.5 ? 4*t*t*t : 1 - Math.pow(-2*t + 2, 3) / 2;
        window.scrollTo(0, from + d * e);
        if (t < 1) requestAnimationFrame(step); else done(1);
      }
      requestAnimationFrame(step);
    });
  };

  window.__lkZoom = function (sc, ox, oy, ms) {
    return new Promise(function (done) {
      var b = document.body, s = performance.now();
      var m = /scale\\(([\\d.]+)\\)/.exec(b.style.transform || '');
      var from = m ? parseFloat(m[1]) : 1;
      b.style.transformOrigin = ox + 'px ' + oy + 'px';
      function step(now) {
        var t = Math.min(1, (now - s) / ms);
        // easeInOutCubic. easeOutCubic starts at full speed, which reads as a snap
        // at the top of a push-in; this eases in and out of the move.
        var e = t < 0.5 ? 4*t*t*t : 1 - Math.pow(-2*t + 2, 3) / 2;
        var v = from + (sc - from) * e;
        // Never leave scale(1) behind: an identity transform still creates a
        // containing block, which breaks position:fixed for anything inside body.
        if (t >= 1 && sc === 1) { b.style.transform = 'none'; b.style.transformOrigin = ''; }
        else b.style.transform = 'scale(' + v + ')';
        if (t < 1) requestAnimationFrame(step); else done(1);
      }
      requestAnimationFrame(step);
    });
  };

  window.__lkRing = function (x, y) {
    var r = document.getElementById('lk-ring');
    if (!r) return;
    r.style.left = x + 'px'; r.style.top = y + 'px';
    r.classList.remove('go'); void r.offsetWidth; r.classList.add('go');
  };
  window.__lkCap = function (t) {
    var e = document.getElementById('lk-cap');
    if (!e) return;
    e.innerHTML = '';
    var dot = document.createElement('span'); dot.className = 'lk-dot';
    e.appendChild(dot);
    e.appendChild(document.createTextNode(t));
    // Restart the pop so a back-to-back caption animates again instead of
    // swapping its text in place.
    e.classList.remove('on'); void e.offsetWidth; e.classList.add('on');
  };
  window.__lkCapOff = function () {
    var e = document.getElementById('lk-cap'); if (e) e.classList.remove('on');
  };
  return 'ok';
})()`;

const wait = (p: Page, ms: number) => p.waitForTimeout(ms);

async function overlay(page: Page) {
  await page.addStyleTag({ content: CSS });
  const r = await page.evaluate(INSTALL);
  if (r !== 'ok' && r !== 'already') throw new Error('overlay install failed: ' + r);
}

const scrollTo = async (p: Page, y: number, ms = 1400) => {
  await p.evaluate(`window.__lkScroll(${y},${ms})`);
  await wait(p, 240);
};
const zoom = (p: Page, s: number, x: number, y: number, ms = 900) =>
  p.evaluate(`window.__lkZoom(${s},${x},${y},${ms})`);
const unzoom = (p: Page, ms = 900) => p.evaluate(`window.__lkZoom(1,960,0,${ms})`);
const cap = async (p: Page, text: string, hold = 2300) => {
  await p.evaluate(`window.__lkCap(${JSON.stringify(text)})`);
  await wait(p, hold);
};
const capOff = async (p: Page, hold = 460) => {
  await p.evaluate(`window.__lkCapOff()`);
  await wait(p, hold);
};

async function moveTo(page: Page, sel: string, ms = 760) {
  const el = page.locator(sel).first();
  await el.scrollIntoViewIfNeeded().catch(() => {});
  await wait(page, 220);
  const b = await el.boundingBox();
  if (!b) throw new Error('no box: ' + sel);
  const x = Math.round(b.x + b.width / 2), y = Math.round(b.y + b.height / 2);
  await page.evaluate(`window.__lkMove(${x},${y},${ms})`);
  return { x, y };
}
async function click(page: Page, sel: string, settle = 1000) {
  const { x, y } = await moveTo(page, sel);
  await page.evaluate(`window.__lkRing(${x},${y})`);
  await wait(page, 260);
  await page.locator(sel).first().click({ timeout: 9000 }).catch(() => {});
  await wait(page, settle);
}

/**
 * Push in on an element and hold there. Anchors the transform origin to the
 * element's own centre so it grows in place instead of sliding across frame.
 */
async function zoomTo(
  page: Page,
  sel: string,
  scale: number,
  ms = 1150,
  originY: 'center' | 'top' = 'center',
) {
  const b = await page.locator(sel).first().boundingBox();
  if (!b) return false;
  const ox = Math.round(b.x + b.width / 2);
  // 'top' pins the element's top edge and lets it grow downward. Use it for a
  // container whose header carries the context (who you are talking to); a centre
  // origin pushes that header up out of frame.
  const oy = originY === 'top' ? Math.round(b.y) : Math.round(b.y + b.height / 2);
  await page.evaluate(`window.__lkZoom(${scale},${ox},${oy},${ms})`);
  await wait(page, ms + 120);
  return true;
}

/**
 * Click a field, push in on it, then type.
 *
 * Typing is the one moment where the viewer has to read individual characters
 * appearing, so it gets the tightest framing in the video. The zoom lands BEFORE
 * the first keystroke: pushing in afterwards means the interesting part already
 * happened at whatever size the page happened to be.
 *
 * Clicking while zoomed is safe because Playwright's boundingBox() already
 * reports post-transform viewport coordinates, and the cursor overlay lives
 * outside body so it is not scaled along with the page.
 */
async function typeInto(
  page: Page,
  sel: string,
  text: string,
  opts: {
    scale?: number; delay?: number; settle?: number;
    anchor?: string; originY?: 'center' | 'top';
  } = {},
) {
  const { scale = 1.8, delay = 78, settle = 700, anchor, originY = 'center' } = opts;
  await click(page, sel, 320);
  // Anchor on the surrounding card when one is given. Scaling around a field that
  // sits low in a short page throws half the frame away as empty background: the
  // content above it moves up and out, and nothing moves in to replace it.
  await zoomTo(page, anchor || sel, scale, 1150, originY);
  await page.keyboard.type(text, { delay });
  await wait(page, settle);
}
let PAGE: Page;
async function scene(n: string, fn: () => Promise<void>) {
  try {
    if (PAGE) await overlay(PAGE).catch(() => {});   // Turbo navigations strip injected nodes
    await fn();
    console.log('  ok   ' + n);
  }
  catch (e: any) { console.log('  FAIL ' + n + ': ' + String(e.message).slice(0, 120)); }
}

const END_CARD = `(function(){
  document.body.style.transform = 'none';
  var e = document.createElement('div');
  e.innerHTML = '<div style="text-align:center;transform:translateY(-6px)">' +
    '<div style="display:flex;align-items:center;justify-content:center">' +
    '<span style="font:700 132px/1 -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica;color:#0a66c2;letter-spacing:-.045em;margin-right:12px">Larp</span>' +
    '<span style="width:152px;height:152px;border-radius:22px;background:#0a66c2;color:#fff;font:700 98px/1 -apple-system,BlinkMacSystemFont,Segoe UI,Helvetica;display:flex;align-items:center;justify-content:center;letter-spacing:-.045em">in</span>' +
    '</div>' +
    '<p style="margin:30px 0 0;font:700 42px -apple-system,BlinkMacSystemFont,Segoe UI;color:#0a66c2">larpin.io</p>' +
    '<p style="margin:10px 0 0;font:500 27px -apple-system,BlinkMacSystemFont,Segoe UI;color:#5b6b7c">open source, no signup</p>' +
    '</div>';
  e.style.cssText = 'position:fixed;top:0;left:0;width:100vw;height:100vh;background:#f4f2ee;' +
    'z-index:2147483647;display:flex;align-items:center;justify-content:center;opacity:0;' +
    'transition:opacity .55s cubic-bezier(.2,.7,.3,1)';
  document.body.appendChild(e);
  requestAnimationFrame(function(){ e.style.opacity = '1'; });
  return 'ok';
})()`;

async function run(page: Page) {
  PAGE = page;
  await page.goto(BASE, { waitUntil: 'networkidle' });
  await wait(page, 800);
  await scene('0 welcome', async () => {
    const b = page.getByRole('button', { name: /start larpmaxxing/i }).first();
    if (await b.isVisible({ timeout: 4000 })) { await b.click(); await wait(page, 700); }
  });
  await overlay(page);
  await wait(page, 700);

  await scene('1 feed', async () => {
    await cap(page, 'One global feed. Everyone lands in the same place.', 2500);
    await capOff(page);
    await scrollTo(page, 620, 1700);
    await scrollTo(page, 1180, 1500);
    await scrollTo(page, 0, 1500);
  });

  await scene('2 larp level + react', async () => {
    await cap(page, 'Every post is scored on buzzword density.', 2200);
    await capOff(page);
    await scrollTo(page, 300, 1100);
    await click(page, 'button:has-text("React")', 800);
    await click(page, 'text=Grindset', 1400);
  });

  await scene('3 larpmaxx', async () => {
    await scrollTo(page, 0, 1100);
    await cap(page, 'Larpmaxx turns any word into a whole post.', 2300);
    await capOff(page);
    // Tight on the composer while the word goes in, then stay zoomed through the
    // click so the generated post writes itself at the same size the typing was at.
    await typeInto(page, 'textarea', 'stealth', { scale: 1.9, delay: 150, settle: 800 });
    await click(page, 'button:has-text("Larpmaxx")', 2600);
    await zoom(page, 1.45, 960, 130, 1100);
    await wait(page, 2900);
    await unzoom(page, 900);
    await wait(page, 400);
  });

  await scene('4 dms', async () => {
    await scrollTo(page, 560, 1300);
    await cap(page, 'DM anyone. No connection request.', 2300);
    await capOff(page);
    // Reach out to a SEEDED BOT specifically. Most feed authors are generated visitor
    // personas, and MessagesController only fires the instant reply when other.is_bot,
    // so DMing a visitor leaves a one-sided empty thread on camera.
    const botCard = page.locator('article.card')
      .filter({ hasText: /Maverick Blackwood|Chadwick Sterling III|Sir Reginald/ }).first();
    await botCard.scrollIntoViewIfNeeded();
    await wait(page, 300);
    const reach = botCard.getByRole('button', { name: /reach out/i }).first();
    const rb = await reach.boundingBox();
    if (rb) {
      await page.evaluate(`window.__lkMove(${Math.round(rb.x + rb.width / 2)},${Math.round(rb.y + rb.height / 2)},760)`);
      await page.evaluate(`window.__lkRing(${Math.round(rb.x + rb.width / 2)},${Math.round(rb.y + rb.height / 2)})`);
      await wait(page, 260);
    }
    await reach.click({ timeout: 9000 });
    await page.waitForLoadState('networkidle').catch(() => {});
    await overlay(page);
    await wait(page, 600);
    // Push in on the message field and type there. The old version stayed wide
    // because a fixed zoom mis-framed the card as its height changed; anchoring the
    // origin to the field itself fixes that, and the send button stays clickable
    // while zoomed now that the cursor overlay is outside the transformed body.
    // Modest push-in while typing, because the thread is still empty at this point
    // and a hard zoom would just magnify white space. It goes tighter after the send,
    // once there is an actual exchange worth filling the frame with.
    await typeInto(page, 'input[name="message[body]"]', 'quick question, are you free to circle back',
      { scale: 1.4, delay: 72, settle: 850, anchor: 'div.card', originY: 'top' });
    await click(page, 'input[type="submit"][value="Send"]', 1000);
    await page.waitForLoadState('networkidle').catch(() => {});
    // Pull back out so the reply lands in frame, then push in on the whole exchange.
    // Measuring has to happen unzoomed: boundingBox reports post-transform pixels,
    // so sizing a zoom off a zoomed measurement compounds the scale.
    await unzoom(page, 700);
    // Two bubbles, not one. Our own message paints immediately; the bot's reply is a
    // live model call now, so the interesting half of the shot arrives a second later.
    await page.locator('div.rounded-2xl').nth(1).waitFor({ timeout: 15000 }).catch(() => {});
    await wait(page, 600);
    const card = page.locator('div.card').first();
    const cb = await card.boundingBox();
    if (cb) {
      const target = 1080 * 0.72;
      const sc = Math.max(1.35, Math.min(2.3, target / Math.max(cb.height, 1)));
      const ox = Math.round(cb.x + cb.width / 2);
      const oy = Math.round(cb.y);
      await page.evaluate(`window.__lkZoom(${sc.toFixed(2)},${ox},${oy},1150)`);
    }
    await wait(page, 3400);   // hold on our message plus the bot's reply
    await unzoom(page, 900);
    await wait(page, 400);
  });

  await scene('5 larpboard', async () => {
    await page.goto(BASE + '/larpboard', { waitUntil: 'networkidle' });
    await overlay(page); await wait(page, 700);
    await cap(page, 'The follower counts are openly fake. People compete over them.', 2600);
    await capOff(page);
    await scrollTo(page, 420, 1700);
    await scrollTo(page, 0, 1200);
  });

  await scene('6 jobs', async () => {
    await page.goto(BASE + '/jobs', { waitUntil: 'networkidle' });
    await overlay(page); await wait(page, 700);
    await cap(page, 'Easy Apply rejects you instantly.', 2100);
    await capOff(page);
    await click(page, 'button:has-text("Easy Apply")', 1600);
    await zoom(page, 1.35, 960, 70, 900);
    await wait(page, 2400);
    await unzoom(page);
  });

  await scene('7 end card', async () => {
    await page.evaluate(END_CARD);
    await wait(page, 2900);
  });
}

(async () => {
  fs.rmSync(TMP, { recursive: true, force: true });
  fs.mkdirSync(TMP, { recursive: true });
  const browser: Browser = await chromium.launch({
    headless: true,
    args: ['--force-device-scale-factor=2', '--high-dpi-support=1', '--hide-scrollbars',
           '--force-color-profile=srgb'],
  });
  const ctx: BrowserContext = await browser.newContext({
    viewport: { width: 1920, height: 1080 },
    deviceScaleFactor: 2,
    recordVideo: { dir: TMP, size: { width: 3840, height: 2160 } },
  });
  const page = await ctx.newPage();
  console.log('recording ' + BASE + ' at 3840x2160 ...');
  try { await run(page); } finally { await ctx.close(); await browser.close(); }
  const webm = fs.readdirSync(TMP).find((f) => f.endsWith('.webm'));
  if (!webm) throw new Error('no video produced');
  fs.copyFileSync(path.join(TMP, webm), path.join(TMP, 'raw.webm'));
  console.log('raw capture: ' + path.join(TMP, 'raw.webm'));
})();
