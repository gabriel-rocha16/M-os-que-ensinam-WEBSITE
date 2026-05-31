// app/javascript/controllers/sidebar_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "main"]

  toggle() {
    this.sidebarTarget.classList.toggle("w-[280px]")
    this.sidebarTarget.classList.toggle("w-[80px]")
    // Opcional: esconder textos quando estiver pequena
    this.sidebarTarget
      .querySelectorAll(".nav-text")
      .forEach((el) => el.classList.toggle("hidden"))
  }
}
