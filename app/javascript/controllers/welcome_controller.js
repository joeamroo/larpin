import { Controller } from "@hotwired/stimulus"

// First-visit welcome dialog. Shows once (localStorage), or when ?welcome=1
// forces it back (used by the persona reroll flow).
export default class extends Controller {
  static targets = ["overlay", "card"]

  connect() {
    const seen = localStorage.getItem("larpin_welcomed")
    const forced = new URLSearchParams(window.location.search).has("welcome")
    if (seen && !forced) return

    this.overlayTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
    requestAnimationFrame(() => {
      this.cardTarget.classList.remove("translate-y-4", "opacity-0")
    })
    this.onKey = (e) => { if (e.key === "Escape") this.dismiss() }
    document.addEventListener("keydown", this.onKey)
  }

  dismiss() {
    localStorage.setItem("larpin_welcomed", "1")
    this.cardTarget.classList.add("translate-y-4", "opacity-0")
    document.body.style.overflow = ""
    setTimeout(() => this.overlayTarget.classList.add("hidden"), 250)
    document.removeEventListener("keydown", this.onKey)
    if (window.location.search.includes("welcome=")) {
      history.replaceState({}, "", window.location.pathname)
    }
  }

  disconnect() {
    document.body.style.overflow = ""
    document.removeEventListener("keydown", this.onKey)
  }
}
