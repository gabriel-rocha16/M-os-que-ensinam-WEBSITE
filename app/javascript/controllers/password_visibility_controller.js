import { Controller } from "@hotwired/stimulus"
import { createIcons, Eye, EyeOff } from "lucide"

export default class extends Controller {
  static targets = ["input", "icon"]

  toggle() {
    // 1. Verifica o tipo atual do input (true se for password)
    const isPassword = this.inputTarget.type === "password"

    // 2. Alterna o tipo entre 'password' e 'text'
    this.inputTarget.type = isPassword ? "text" : "password"

    // 3. Define o nome do próximo ícone
    const nextIcon = isPassword ? "eye" : "eye-off"

    // 4. Substitui o ícone antigo dentro do botão por uma nova tag <i> limpa
    this.iconTarget.innerHTML = `<i data-lucide="${nextIcon}" class="w-5 h-5"></i>`

    // 5. Força o Lucide a transformar a nova tag <i> em SVG
    createIcons({
      icons: { Eye, EyeOff },
    })
  }
}
