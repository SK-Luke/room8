import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["choreCard", "choresList","form", "editBtn"]

  connect() {
    console.log("hello from setup_chores_controller!")
  }

  highlight(event) {
    event.preventDefault();
    const element = event.path.find(element => element.className.includes("chore_card"))
    if (element.className === "chore_card") {
      element.className = "chore_card_selected"
      const details = element.getElementsByClassName("chore_details")
      // using array from bc foreach method does not work on html collection
      Array.from(details).forEach(detail => detail.className = "chore_details_selected")
      const edtbtn = element.querySelector(".chore_edit_button")
      console.log(edtbtn)
      edtbtn.className = "chore_edit_button_display"
      //edtbtn.className = "chore_edit_button_display"
      //this.editBtnTarget.style.display = "block"
    } else {
      element.className = "chore_card"
      const selected_details = element.getElementsByClassName("chore_details_selected")
      Array.from(selected_details).forEach(detail => detail.className = "chore_details")
      const edtbtn = element.querySelector(".chore_edit_button_display")
      console.log(edtbtn)
      //edtbtn.className = "chore_edit_button"
      edtbtn.className = "chore_edit_button"
      //this.editBtnTarget.style.display = "none"
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
      .then(response =>
        response.json()
        )
      .then((data) => {
        console.log(data)
        const modal = document.getElementById("addChoreModal");
        modal.style.display = "none";
        if (data.inserted_item) {
          this.choresListTarget.insertAdjacentHTML("afterbegin", data.inserted_item)
        }
        this.formTarget.outerHTML = data.form
      })
      //location.reload();
  }
}
