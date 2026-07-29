import { Controller } from "@hotwired/stimulus"

// Reloads a turbo-frame on an interval so DMs feel alive without websockets.
export default class extends Controller {
  static values = { interval: { type: Number, default: 8000 } }

  connect() {
    this.timer = setInterval(() => {
      if (document.visibilityState === "visible" && this.element.reload) this.element.reload()
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}
