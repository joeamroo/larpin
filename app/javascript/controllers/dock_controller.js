import { Controller } from "@hotwired/stimulus"

// The bottom-right chat dock. Opens and closes panels and remembers which ones
// were open, so a page navigation does not close the chat you were mid-sentence in.
export default class extends Controller {
  static targets = ["body", "chevron", "scroller"]

  connect() {
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
      requestAnimationFrame(() => this.scrollBottom())
    }
  }

  // Chat reads bottom-up. Called on every frame load, including the polled ones.
  scrollBottom() {
    this.scrollerTargets.forEach((el) => {
      el.scrollTop = el.scrollHeight
    })
  }

  storageKey(key) {
    return `larpin:dock:${key}`
  }
}
