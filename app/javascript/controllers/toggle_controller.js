import { Controller } from "@hotwired/stimulus"

// Generic named-panel toggler. Panels declare data-panel="name" and optionally
// data-toggle-class (defaults to "hidden").
export default class extends Controller {
  static targets = ["panel"]

  toggle(event) {
    const name = event.params.name
    this.panelTargets.forEach((panel) => {
      if (!name || panel.dataset.panel === name) {
        panel.classList.toggle(panel.dataset.toggleClass || "hidden")
      }
    })
  }
}
