import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="cpf-mask"
export default class extends Controller {
  connect() {
    this.element.addEventListener('input', this.mask.bind(this))
    this.mask({ target: this.element }) // Formata o valor inicial caso exista
  }

  mask(e) {
    let value = e.target.value.replace(/\D/g, '') // Remove tudo o que não é dígito
    if (value.length > 11) value = value.slice(0, 11) // Limita a 11 dígitos
    
    // Aplica a máscara 000.000.000-00
    value = value.replace(/(\d{3})(\d)/, '$1.$2')
    value = value.replace(/(\d{3})(\d)/, '$1.$2')
    value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2')
    
    e.target.value = value
  }
}
