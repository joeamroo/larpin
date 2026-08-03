import { Controller } from "@hotwired/stimulus"

// Reloads a turbo-frame on an interval so DMs feel alive without websockets.
export default class extends Controller {
  static values = { interval: { type: Number, default: 8000 } }

  connect() {
    this.timer = setInterval(() => {
      if (this.shouldReload()) this.element.reload()
    }, this.intervalValue)
  }

  shouldReload() {
    // A src-less frame cannot reload at all.
    if (!this.element.src || !this.element.reload) return false
    if (document.visibilityState !== "visible") return false

    // offsetParent is null inside a collapsed dock panel, so a closed panel stops
    // polling instead of quietly hitting the server every few seconds forever.
    if (this.element.offsetParent === null) return false

    // Never reload out from under someone who is using this frame.
    //
    // Reloading replaces the frame's contents wholesale, which destroys the very
    // input they are typing into: the half-written message is wiped, the node is
    // swapped, and focus falls back to <body>, where the next space or arrow key
    // scrolls the page instead of the chat. A poll must never interrupt a draft.
    if (this.element.contains(document.activeElement)) return false
    if (this.hasDraft()) return false

    return true
  }

  // A message someone started and walked away from still counts. Losing it
  // because a timer fired while they were not looking is the same bug.
  hasDraft() {
    return Array.from(this.element.querySelectorAll("input[type='text'], textarea"))
      .some((field) => field.value.trim() !== "")
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
