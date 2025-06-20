import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  static values = { target: String }

  open(event) {
    event.preventDefault()
    const modalId = this.targetValue || this.data.get("target")
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.classList.remove("hidden")
      modal.classList.add("flex")
      document.body.classList.add("overflow-hidden")
    }
  }

  close(event) {
    if (event) event.preventDefault()
    const modal = this.element.closest("[data-modal]") || this.element
    modal.classList.add("hidden")
    modal.classList.remove("flex")
    document.body.classList.remove("overflow-hidden")
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) {
      this.close(event)
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close(event)
    }
  }

  connect() {
    document.addEventListener("keydown", this.closeOnEscape.bind(this))
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeOnEscape.bind(this))
  }
}