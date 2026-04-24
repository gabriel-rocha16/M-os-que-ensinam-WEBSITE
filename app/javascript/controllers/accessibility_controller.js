import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "contrastBtn", "animationBtn", "animationDot", "percentage", "contrastDot", "animationDot"]

  connect() {
    // Carrega preferências salvas
    this.fontSize = parseFloat(localStorage.getItem("fontSize")) || 100
    this.contrast = localStorage.getItem("contrast") === "true"
    this.reducedMotion = localStorage.getItem("reducedMotion") === "true"
    this.applyChanges()
  }

  togglePanel() {
    this.panelTarget.classList.toggle("hidden")
  }

  increaseFont() {
    if (this.fontSize < 150) this.fontSize += 10
    this.applyChanges()
  }

  decreaseFont() {
    if (this.fontSize > 80) this.fontSize -= 10
    this.applyChanges()
  }

  resetFont() {
    this.fontSize = 100
    this.applyChanges()
  }

  toggleContrast() {
    this.contrast = !this.contrast
    this.applyChanges()
  }

  toggleAnimations() {
    this.reducedMotion = !this.reducedMotion
    this.applyChanges()
  }

  applyChanges() {
    // 1. Aplicar Fonte e Porcentagem
    document.documentElement.style.fontSize = `${this.fontSize}%`
    if (this.hasPercentageTarget) {
      this.percentageTarget.textContent = this.fontSize
    }

    // 2. Lógica do Alto Contraste (Cor + Bolinha)
    if (this.contrast) {
      document.body.classList.add("high-contrast")
      this.contrastBtnTarget.classList.replace("bg-[#D0D0D0]", "bg-[#0066CC]")
      this.contrastDotTarget.classList.replace("translate-x-0", "translate-x-7")
    } else {
      document.body.classList.remove("high-contrast")
      this.contrastBtnTarget.classList.replace("bg-[#0066CC]", "bg-[#D0D0D0]")
      this.contrastDotTarget.classList.replace("translate-x-7", "translate-x-0")
    }

    // 3. Lógica de Redução de Movimento (Cor + Bolinha)
    if (this.reducedMotion) {
      document.documentElement.classList.add("reduce-motion")
      this.animationBtnTarget.classList.replace("bg-[#D0D0D0]", "bg-[#0066CC]")
      this.animationDotTarget.classList.replace(
        "translate-x-0",
        "translate-x-7",
      )
    } else {
      document.documentElement.classList.remove("reduce-motion")
      this.animationBtnTarget.classList.replace("bg-[#0066CC]", "bg-[#D0D0D0]")
      this.animationDotTarget.classList.replace(
        "translate-x-7",
        "translate-x-0",
      )
    }

    // Salvar estados
    localStorage.setItem("fontSize", this.fontSize)
    localStorage.setItem("contrast", this.contrast)
    localStorage.setItem("reducedMotion", this.reducedMotion)
  }

  resetAll() {
    this.fontSize = 100
    this.contrast = false
    this.applyChanges()
  }
}
