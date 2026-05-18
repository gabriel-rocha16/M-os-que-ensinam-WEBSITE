import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "content"];

  connect() {
    this.toggle(); // Checa o estado assim que a página carrega
  }

  toggle() {
    // Se o checkbox estiver marcado, mostra o conteúdo (remove o hidden e adiciona flex)
    if (this.checkboxTarget.checked) {
      this.contentTarget.classList.remove("hidden");
      this.contentTarget.classList.add("flex");
    } else {
      // Se desmarcar, oculta novamente
      this.contentTarget.classList.add("hidden");
      this.contentTarget.classList.remove("flex");
    }
  }
}
