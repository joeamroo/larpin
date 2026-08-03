import { Controller } from "@hotwired/stimulus"

// Reloads a turbo-frame on an interval so DMs feel alive without websockets.
export default class extends Controller {
  static values = { interval: { type: Number, default: 8000 } }

  connect() {
    this.timer = setInterval(() => {
      // Only reload a frame that actually has a src; a src-less frame cannot reload.
      // offsetParent is null inside a collapsed dock panel, so a closed panel
      // stops polling instead of quietly hitting the server every few seconds.
      if (document.visibilityState !== "visible") return
      if (this.element.offsetParent === null) return
      if (this.element.src && this.element.reload) this.element.reload()
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
