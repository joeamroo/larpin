import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "fileInput", "previews", "enhanceBtn", "larpmaxxBtn", "hint", "submit", "kind", "pollBox"]

  connect() {
    this.grow()
    this.validate()
  }

  kindChanged() {
    const isPoll = this.hasKindTarget && this.kindTarget.value === "poll"
    if (this.hasPollBoxTarget) this.pollBoxTarget.classList.toggle("hidden", !isPoll)
    if (this.hasPollBoxTarget) this.pollBoxTarget.classList.toggle("flex", isPoll)
    if (isPoll) this.textareaTarget.placeholder = "Ask the larpers a question..."
    this.validate()
  }

  async larpmaxx() {
    const seed = this.textareaTarget.value.trim().split(/\s+/)[0] || ""
    const original = this.larpmaxxBtnTarget.innerHTML
    // The AI path takes a few seconds. A button that only greys out reads as broken.
    this.larpmaxxBtnTarget.innerHTML = "📈 Maxxing..."
    this.larpmaxxBtnTarget.disabled = true
    try {
      const response = await fetch("/ai/larpmaxx", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.content
        },
        body: JSON.stringify({ seed })
      })
      const data = await response.json()
      if (data.text) {
        this.textareaTarget.value = data.text
        this.grow()
        this.showHint("Larpmaxxed. You need to be posting this.")
      }
    } catch {
      this.showHint("The maxx failed. Stay an NPC for now.")
    } finally {
      this.larpmaxxBtnTarget.innerHTML = original
      this.larpmaxxBtnTarget.disabled = false
    }
  }

  grow() {
    const el = this.textareaTarget
    el.style.height = "auto"
    el.style.height = `${Math.min(el.scrollHeight, 320)}px`
    this.validate()
  }

  validate() {
    if (!this.hasSubmitTarget) return
    const hasText = this.textareaTarget.value.trim().length > 0
    const hasFiles = this.hasFileInputTarget && this.fileInputTarget.files.length > 0
    this.submitTarget.disabled = !(hasText || hasFiles)
  }

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
    this.validate()
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
        this.grow()
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
