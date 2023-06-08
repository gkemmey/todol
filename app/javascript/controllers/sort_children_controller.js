import { Controller } from "@hotwired/stimulus"
import { useMutation } from "stimulus-use";

export default class extends Controller {
  connect() {
    useMutation(this, { childList: true })
  }

  mutate(entries) {
    this.sortChildren()
  }

  // ref: https://github.com/hotwired/turbo/issues/109#issuecomment-761538869

  sortChildren() {
    const { children } = this
    if (elementsAreSorted(children)) { return; }

    children.sort(compareElements).forEach(this.append)
  }

  get children() {
    return Array.from(this.element.children)
  }

  append = child => this.element.append(child)
}

function elementsAreSorted([left, ...rights]) {
  for (const right of rights) {
    if (compareElements(left, right) > 0) return false
    left = right
  }
  return true
}

function compareElements(left, right) {
  return getSortCode(left) - getSortCode(right)
}

function getSortCode(element) {
  return element.getAttribute("data-sort-code") || 0
}
