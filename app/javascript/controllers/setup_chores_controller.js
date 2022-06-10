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
      const details = element.getElementsByClassName("chore_details")
      // using array from bc foreach method does not work on html collection
      Array.from(details).forEach(detail => detail.className = "chore_details_selected")
    } else {
      element.className = "chore_card"
      const selected_details = element.getElementsByClassName("chore_details_selected")
      Array.from(selected_details).forEach(detail => detail.className = "chore_details")
    }
  }
  addChore(event) {
    event.preventDefault();
    console.log(event)
    const modal = document.getElementById("addChoreModal");
    modal.style.display = "block";
  }

  modalClose(event) {
    event.preventDefault();
    const modal = document.getElementById("addChoreModal");
    modal.style.display = "none";
  }
  send(event) {
    event.preventDefault()

    fetch(this.formTarget.action, {
      method: "POST",
      headers: { "Accept": "application/json", "X-CSRF-Token": csrfToken() },
      body: new FormData(this.formTarget)
    })
      .then(response => response.json())
      .then((data) => {
        console.log(data)
      })
  }
}
