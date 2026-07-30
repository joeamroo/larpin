import { Controller } from "@hotwired/stimulus"

// Dropdown menu: toggles open, closes on outside click or Escape.
export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.close = this.close.bind(this)
    this.onKey = (e) => { if (e.key === "Escape") this.close() }
  }

  toggle(event) {
    event.stopPropagation()
    const isHidden = this.panelTarget.classList.contains("hidden")
    if (isHidden) {
      this.panelTarget.classList.remove("hidden")
      document.addEventListener("click", this.close)
      document.addEventListener("keydown", this.onKey)
    } else {
      this.close()
    }
  }

  close() {
    this.panelTarget.classList.add("hidden")
    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.onKey)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.onKey)
  }
}
