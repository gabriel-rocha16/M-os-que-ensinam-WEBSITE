import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["backdrop", "container"]

  open() {
    this.backdropTarget.classList.remove("hidden")
    setTimeout(() => {
      this.backdropTarget.classList.remove("opacity-0")
      this.containerTarget.classList.remove("-translate-x-full")
    }, 20)
  }

  close() {
    this.backdropTarget.classList.add("opacity-0")
    this.containerTarget.classList.add("-translate-x-full")

    setTimeout(() => {
      this.backdropTarget.classList.add("hidden")
    }, 300)
  }
}
