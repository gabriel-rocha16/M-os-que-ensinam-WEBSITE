import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "menu",
    "chevron",
    "container",
    "otherCheckbox",
    "otherInputWrapper",
    "otherContainer",
  ];

  toggle(event) {
    if (event) event.stopPropagation();

    // Alterna a visibilidade (remove 'hidden' e adiciona 'flex')
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

  toggleOther() {
    // Se marcou "Outros", mostra o input de texto e pinta a borda de azul (fiel ao anexo 3)
    if (this.otherCheckboxTarget.checked) {
      this.otherInputWrapperTarget.classList.remove("hidden");
      this.otherContainerTarget.classList.add("border-[#0066CC]", "border-2");
      this.otherContainerTarget.classList.remove("border-[#D0D0D0]");
    } else {
      // Se desmarcou, oculta o input e volta a borda pro cinza padrão
      this.otherInputWrapperTarget.classList.add("hidden");
      this.otherContainerTarget.classList.remove(
        "border-[#0066CC]",
        "border-2",
      );
      this.otherContainerTarget.classList.add("border-[#D0D0D0]");
    }
  }
}
