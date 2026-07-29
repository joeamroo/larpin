import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "fileInput", "previews", "enhanceBtn", "hint"]

  previewImages() {
    this.previewsTarget.innerHTML = ""
    const files = Array.from(this.fileInputTarget.files).slice(0, 4)
    if (this.fileInputTarget.files.length > 4) {
      this.showHint("Maximum 4 images. This isn't Instagram.")
    }
    files.forEach((file) => {
      if (!file.type.startsWith("image/")) return
      const img = document.createElement("img")
      img.className = "w-16 h-16 object-cover rounded-lg border border-black/10"
      img.src = URL.createObjectURL(file)
      this.previewsTarget.appendChild(img)
    })
  }

  async enhance() {
    const draft = this.textareaTarget.value.trim()
    if (!draft) {
      this.showHint("Write something first. Even a lie needs a first draft.")
      return
    }
    const original = this.enhanceBtnTarget.innerHTML
    this.enhanceBtnTarget.innerHTML = "✨ Fabricating..."
    this.enhanceBtnTarget.disabled = true
    try {
      const response = await fetch("/ai/enhance", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({ draft })
      })
      const data = await response.json()
      if (response.ok && data.text) {
        this.textareaTarget.value = data.text
        this.textareaTarget.style.height = "auto"
        this.textareaTarget.rows = Math.min(14, data.text.split("\n").length + 2)
        this.showHint("Enhanced. You are now 40% more insufferable.")
      } else {
        this.showHint(data.error || "Enhancement failed. Your authenticity survives another day.")
      }
    } catch {
      this.showHint("Enhancement failed. Your authenticity survives another day.")
    } finally {
      this.enhanceBtnTarget.innerHTML = original
      this.enhanceBtnTarget.disabled = false
    }
  }

  showHint(text) {
    this.hintTarget.textContent = text
    this.hintTarget.classList.remove("hidden")
    clearTimeout(this._hintTimer)
    this._hintTimer = setTimeout(() => this.hintTarget.classList.add("hidden"), 5000)
  }
}
