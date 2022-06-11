import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["choreCard", "choresList","form","editForm"]
  static values = {
    flatid: String
  }

  connect() {
    console.log("hello from setup_chores_controller!")
  }

  highlight(event) {
    event.preventDefault();
    const element = event.path.find(element => element.className.includes("chore_card"))
    console.log(element)
    console.log(element.className)
    const modal = document.getElementById(`edit-${element.id}-modal`);
    if ((element.className === "chore_card") && (modal.style.display === "none"||modal.style.display === "")) {
      element.className = "chore_card_selected";
      const details = element.getElementsByClassName("chore_details");
      // using array from bc foreach method does not work on html collection
      Array.from(details).forEach(detail => detail.className = "chore_details_selected");
      const edtbtn = element.querySelector(".chore_edit_button");
      console.log(edtbtn)
      edtbtn.className = "chore_edit_button_display";
    } else if ((element.className === "chore_card_selected") && (modal.style.display === "none"||modal.style.display === "")) {
      element.className = "chore_card";
      const selected_details = element.getElementsByClassName("chore_details_selected");
      Array.from(selected_details).forEach(detail => detail.className = "chore_details");
      const edtbtn = element.querySelector(".chore_edit_button_display");
      edtbtn.className = "chore_edit_button";
    }
  }
  addChore(event) {
    event.preventDefault();
    // console.log(event)
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
        // console.log(data)
        const modal = document.getElementById("addChoreModal");
        modal.style.display = "none";
        if (data.inserted_item) {
          this.choresListTarget.insertAdjacentHTML("afterbegin", data.inserted_item)
        }
        this.formTarget.outerHTML = data.form
      })
  }

  editModalClose(event) {
    event.preventDefault();
    console.log(event)
    const modal = event.path.find(element => element.id.includes("edit-chore"))
    //console.log(element)
    //const modal = document.getElementById(`edit-${element.id}-modal`);
    modal.style.display = "none";
  }

  editFormAppear(event){
    event.preventDefault();
    const element = event.path.find(element => element.className.includes("chore_card"))
    const modal = document.getElementById(`edit-${element.id}-modal`);
    modal.style.display = "block";
  }

  update(event) {
    event.preventDefault()
    const modal = event.path.find(element => element.id.includes("edit-chore"))
    let choreCard = document.getElementById(`chore-${modal.id.match(/\d+/)[0]}`)
    console.log(choreCard)
    const form = event.path.find(element => element.id.includes("edit_chore"))
    const url = `/flats/${this.flatidValue}/chores/${modal.id.match(/\d+/)[0]}`
    console.log(url)
    fetch(url, {
      method: "PATCH",
      headers: { "Accept": "text/plain" },
      body: new FormData(form)
    })
      .then(response => response.text())
      .then((data) => {
        modal.style.display = "none";
        //console.log(data)
        choreCard.outerHTML = data
      })
  }
}
