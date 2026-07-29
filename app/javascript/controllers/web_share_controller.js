import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { title: String, text: String, url: String }

  async share() {
    if (navigator.share) {
      try {
        await navigator.share({ title: this.titleValue, text: this.textValue, url: this.urlValue })
      } catch {
        // user cancelled the share sheet; nothing to do
      }
    } else {
      try {
        await navigator.clipboard.writeText(`${this.textValue} ${this.urlValue}`)
        const original = this.element.textContent
        this.element.textContent = "Copied. Now go be an influencer."
        setTimeout(() => (this.element.textContent = original), 2500)
      } catch {}
    }
  }
}
