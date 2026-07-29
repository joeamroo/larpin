import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.textValue)
      const original = this.element.textContent
      this.element.textContent = "Copied. Go paste it somewhere important."
      setTimeout(() => (this.element.textContent = original), 2000)
    } catch {
      this.element.textContent = this.textValue
    }
  }
}
