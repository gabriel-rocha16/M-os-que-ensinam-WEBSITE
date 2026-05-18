import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "input", "displayText", "chevron"];

  toggle(event) {
    // Impede que o clique no botão ative o hide do window imediatamente
    event.stopPropagation();
    this.menuTarget.classList.toggle("hidden");
    this.chevronTarget.classList.toggle("rotate-180");
  }

  hide(event) {
    // Fecha a caixinha se clicar fora dela
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
      this.chevronTarget.classList.remove("rotate-180");
    }
  }

  select(event) {
    // Pega o valor clicado, atualiza o input invisível e o texto do botão
    const value = event.currentTarget.dataset.value;
    this.inputTarget.value = value;
    this.displayTextTarget.textContent = value;
    this.displayTextTarget.classList.add("text-[#333]"); // Muda a cor pra indicar que foi preenchido

    // Fecha a caixinha
    this.menuTarget.classList.add("hidden");
    this.chevronTarget.classList.remove("rotate-180");
  }
}
