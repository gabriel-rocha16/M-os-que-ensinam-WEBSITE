import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu", "chevron", "displayText", "headerText"];

  toggle(event) {
    if (event) event.stopPropagation();

    if (this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.remove("hidden");
      this.menuTarget.classList.add("flex");
      this.chevronTarget.classList.add("rotate-180");
    } else {
      this.menuTarget.classList.add("hidden");
      this.menuTarget.classList.remove("flex");
      this.chevronTarget.classList.remove("rotate-180");
    }
  }

  select(event) {
    // Pega o valor do radio button selecionado
    const value = event.target.value;

    // Atualiza o texto e muda a cor para preto, indicando que foi preenchido
    this.displayTextTarget.textContent = value;
    this.headerTextTarget.classList.remove("text-[#666]");
    this.headerTextTarget.classList.add("text-[#333]");

    // Fecha o acordeão suavemente após um breve momento para o usuário ver a seleção
    setTimeout(() => {
      this.menuTarget.classList.add("hidden");
      this.menuTarget.classList.remove("flex");
      this.chevronTarget.classList.remove("rotate-180");
    }, 200);
  }
}
