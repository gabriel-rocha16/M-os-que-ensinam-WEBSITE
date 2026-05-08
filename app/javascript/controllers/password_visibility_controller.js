import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    // Verifica o tipo atual do input
    const isPassword = this.inputTarget.type === "password"

    // Alterna o tipo entre 'password' e 'text'
    this.inputTarget.type = isPassword ? "text" : "password"

    // Alterna a classe do ícone (olho aberto / olho fechado)
    this.iconTarget.classList.toggle("ri-eye-line")
    this.iconTarget.classList.toggle("ri-eye-off-line")
  }
}