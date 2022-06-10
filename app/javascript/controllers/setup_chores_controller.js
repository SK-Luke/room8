import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["choreCard"]

  connect() {
    console.log("hello from setup_chores_controller!")
  }

  highlight(event) {
    event.preventDefault();
    const element = event.path.find(element => element.className.includes("chore_card"))
    console.log(element)
    if (element.className === "chore_card") {
      element.className = "chore_card_selected"
      let details = element.getElementsByClassName("chore_details")
      // using array from bc foreach method does not work on html collection
      Array.from(details).forEach(detail => detail.className = "chore_details_selected")
    } else {
      element.className = "chore_card"
      let details = element.getElementsByClassName("chore_details_selected")
      Array.from(details).forEach(detail => detail.className = "chore_details")
    }
  }
}
