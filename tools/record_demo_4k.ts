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

const CSS = `
  *{scrollbar-width:none!important}
  ::-webkit-scrollbar{display:none!important}
  #lk-cursor{position:fixed;left:0;top:0;width:32px;height:32px;z-index:2147483647;
    pointer-events:none;will-change:transform;filter:drop-shadow(0 3px 7px rgba(0,0,0,.4))}
  #lk-ring{position:fixed;left:0;top:0;width:16px;height:16px;border-radius:50%;
    border:3px solid #e3b04b;z-index:2147483646;pointer-events:none;opacity:0}
  #lk-ring.go{animation:lkring .6s cubic-bezier(.2,.7,.3,1)}
  @keyframes lkring{0%{opacity:.95;transform:translate(-50%,-50%) scale(.25)}
    100%{opacity:0;transform:translate(-50%,-50%) scale(3.4)}}
  #lk-cap{position:fixed;left:80px;bottom:74px;z-index:2147483645;background:#101a24;
    color:#fff;padding:17px 24px;border-radius:13px;border-left:5px solid #e3b04b;
    font:600 26px/1.34 -apple-system,BlinkMacSystemFont,"Segoe UI",Helvetica,Arial;
    max-width:780px;opacity:0;transform:translateY(14px);
    transition:opacity .42s cubic-bezier(.2,.7,.3,1),transform .42s cubic-bezier(.2,.7,.3,1);
    box-shadow:0 16px 40px rgba(0,0,0,.28)}
  #lk-cap.on{opacity:1;transform:translateY(0)}
`;

// Installed as a plain string: no transpiler helpers reach the page.
const INSTALL = `(function(){
  if (document.getElementById('lk-cursor') && document.getElementById('lk-ring')) return 'already';
  var old = document.getElementById('lk-cursor'); if (old) old.remove();
  var c = document.createElement('div');
  c.id = 'lk-cursor';
  c.innerHTML = '<svg viewBox="0 0 24 24" width="32" height="32"><path d="M5 3 L19 12 L12 13.5 L9.5 20 Z" fill="#fff" stroke="#0b0b0b" stroke-width="1.5"/></svg>';
  document.body.appendChild(c);
  var r = document.createElement('div'); r.id = 'lk-ring'; document.body.appendChild(r);
  var cap = document.createElement('div'); cap.id = 'lk-cap'; document.body.appendChild(cap);
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
        var t = Math.min(1, (now - s) / ms), v = from + (sc - from) * (1 - Math.pow(1 - t, 3));
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
    e.textContent = t; e.classList.add('on');
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
const unzoom = (p: Page, ms = 750) => p.evaluate(`window.__lkZoom(1,960,0,${ms})`);
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
    await click(page, 'textarea', 600);
    await page.keyboard.type('stealth', { delay: 130 });
    await wait(page, 800);
    await click(page, 'button:has-text("Larpmaxx")', 2600);
    await zoom(page, 1.3, 960, 130, 950);
    await wait(page, 2600);
    await unzoom(page);
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
    // Stay wide while typing: at 4K the text is legible, and a fixed zoom mis-frames
    // the card because its height changes as messages land.
    await click(page, 'input[name="message[body]"]', 400);
    await page.keyboard.type('quick question, are you free to circle back', { delay: 62 });
    await wait(page, 900);
    await click(page, 'input[type="submit"][value="Send"]', 1000);
    await page.waitForLoadState('networkidle').catch(() => {});
    // Wait for a real bubble. Messages are server-rendered now, but the redirect still
    // needs to paint before we can measure anything.
    await page.locator('div.rounded-2xl').first().waitFor({ timeout: 9000 });
    await wait(page, 700);
    // Measure the conversation card and push in on the actual exchange.
    const card = page.locator('div.card').first();
    const cb = await card.boundingBox();
    if (cb) {
      const target = 1080 * 0.72;
      const sc = Math.max(1.35, Math.min(2.3, target / Math.max(cb.height, 1)));
      const ox = Math.round(cb.x + cb.width / 2);
      const oy = Math.round(cb.y);
      await page.evaluate(`window.__lkZoom(${sc.toFixed(2)},${ox},${oy},950)`);
    }
    await wait(page, 3200);   // hold on our message plus the instant bot reply
    await unzoom(page);
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
