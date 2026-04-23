import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('input', this.mask.bind(this))
    this.mask({ target: this.element })
  }

  mask(e) {
    let value = e.target.value.replace(/\D/g, '')

    if (value.length > 15) {
      value = value.slice(0, 15)
    }

    if (value.length > 11) {
      // Formato internacional: +DDI (DD) 99999-9999
      let ddiLength = value.length - 11
      let ddi = value.slice(0, ddiLength)
      let ddd = value.slice(ddiLength, ddiLength + 2)
      let part1 = value.slice(ddiLength + 2, ddiLength + 7)
      let part2 = value.slice(ddiLength + 7)
      
      let res = `+${ddi}`
      if (ddd) res += ` (${ddd}`
      if (ddd.length === 2) res += `) `
      if (part1) res += `${part1}`
      if (part1.length === 5 || (part1.length === 4 && part2.length === 0)) res += `-`
      if (part2) res += `${part2}`
      value = res
    } else if (value.length > 2) {
      // Formato local: (DD) 99999-9999
      let ddd = value.slice(0, 2)
      let num = value.slice(2)
      
      let part1 = num.length > 4 ? num.slice(0, -4) : num
      let part2 = num.length > 4 ? num.slice(-4) : ""
      
      let res = `(${ddd}) ${part1}`
      if (part2) res += `-${part2}`
      value = res
    }

    e.target.value = value
  }
}
