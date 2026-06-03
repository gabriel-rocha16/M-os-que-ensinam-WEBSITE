import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "trigger"]

  connect() {
    this.hide()
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.menuTarget.classList.contains("block")) {
      this.hide()
    } else {
      this.show()
    }
  }

  closeOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hide()
    }
  }

  hide() {
    this.menuTarget.classList.add("hidden")
    this.menuTarget.classList.remove("block")

    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "false")
    }
  }

  show() {
    this.menuTarget.classList.remove("hidden")
    this.menuTarget.classList.add("block")

    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", "true")
    }
  }
}
