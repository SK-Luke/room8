import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["choreCard"]

  connect() {
    console.log("hello from setup_chores_controller!")
  }

  highlight(event) {
    event.preventDefault();
    const x = event.path.find(element => element.className.includes("chore_card"))
    console.log(x)
  }
}
