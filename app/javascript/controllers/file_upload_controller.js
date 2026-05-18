import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "label"];

  updatePreview() {
    const input = this.inputTarget;
    const label = this.labelTarget;

    if (input.files && input.files.length > 0) {
      if (input.multiple) {
        // Validação: Bloqueia se o usuário selecionar mais de 3 arquivos
        if (input.files.length > 3) {
          alert(
            "Por favor, selecione no máximo 3 arquivos para os laudos médicos.",
          );
          input.value = ""; // Limpa a seleção incorreta
          this.resetLabel();
          return;
        }
        label.textContent = `${input.files.length} arquivo(s) selecionado(s)`;
      } else {
        label.textContent = input.files[0].name;
      }

      label.classList.remove("text-[#0066CC]", "font-medium");
      label.classList.add("text-[#003366]", "font-bold");
    } else {
      this.resetLabel();
    }
  }

  resetLabel() {
    const label = this.labelTarget;
    label.textContent = "Clique ou arraste o arquivo aqui";
    label.classList.remove("text-[#003366]", "font-bold");
    label.classList.add("text-[#0066CC]", "font-medium");
  }
}
