import { Controller } from "@hotwired/stimulus"

// The bottom-right chat dock. Opens and closes panels, remembers which ones were
// open, and keeps your place in a conversation while it polls.
export default class extends Controller {
  static targets = ["body", "chevron"]

  connect() {
    this.saved = {}
    this.bodyTargets.forEach((body) => {
      if (localStorage.getItem(this.storageKey(body.dataset.dockKey)) === "open") {
        this.setOpen(body.dataset.dockKey, true)
      }
    })
  }

  toggle(event) {
    const key = event.params.key
    const body = this.bodyTargets.find((b) => b.dataset.dockKey === key)
    if (!body) return
    this.setOpen(key, body.classList.contains("hidden"))
  }

  setOpen(key, open) {
    const body = this.bodyTargets.find((b) => b.dataset.dockKey === key)
    const chevron = this.chevronTargets.find((c) => c.dataset.dockKey === key)
    if (!body) return

    body.classList.toggle("hidden", !open)
    if (chevron) chevron.textContent = open ? "▼" : "▲"
    localStorage.setItem(this.storageKey(key), open ? "open" : "closed")

    // A lazy frame inside a display:none panel never loads. Nudge it on first open.
    if (open) {
      const frame = body.querySelector("turbo-frame")
      if (frame && frame.getAttribute("loading") === "lazy" && !frame.hasAttribute("complete")) {
        frame.setAttribute("loading", "eager")
      }
      // Opening a panel should always land on the newest message.
      requestAnimationFrame(() => this.jumpToBottom(body))
    }
  }

  // --- Scroll position across polls -----------------------------------------
  //
  // The frame reloads every few seconds. Replacing its contents resets scrollTop,
  // and unconditionally scrolling to the bottom afterwards drags you away from
  // whatever you had scrolled up to read. So: remember where you were, and only
  // stick to the bottom if that is where you already were.

  // How close to the bottom still counts as "following the conversation".
  static BOTTOM_SLACK = 80

  rememberScroll(event) {
    const el = this.scroller(event.target)
    if (!el) return
    const distance = el.scrollHeight - el.scrollTop - el.clientHeight
    this.saved[event.target.id] = {
      atBottom: distance < this.constructor.BOTTOM_SLACK,
      top: el.scrollTop,
    }
  }

  restoreScroll(event) {
    const el = this.scroller(event.target)
    if (!el) return
    const previous = this.saved[event.target.id]
    // No record yet means this is the first load, where the bottom is correct.
    if (!previous || previous.atBottom) el.scrollTop = el.scrollHeight
    else el.scrollTop = previous.top
  }

  jumpToBottom(root) {
    const el = this.scroller(root)
    if (el) el.scrollTop = el.scrollHeight
  }

  scroller(root) {
    if (!root) return null
    return root.matches?.("[data-chat-scroller]") ? root : root.querySelector("[data-chat-scroller]")
  }

  storageKey(key) {
    return `larpin:dock:${key}`
  }
}
