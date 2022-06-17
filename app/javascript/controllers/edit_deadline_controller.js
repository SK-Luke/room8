import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["edit", "form", "formDets"];

  // connect() {
  //   console.log(document.querySelector("#edit-form"));
  //   document
  //     .querySelector(".edit-close")
  //     .addEventListener("click", (e) => console.log("clicked"));
  // }

  openForm() {
    document
      .querySelector(".edit-close")
      .addEventListener("click", this.closeForm);

    console.log(document.querySelector("#edit-form"));
    document.querySelector("#edit-form").classList.add("open");
  }

  closeForm() {
    document
      .querySelector("#edit-form")
      .removeEventListener("click", this.closeForm);
    console.log("close form");
    document.querySelector("#edit-form").classList.remove("open");
  }

  send(event) {
    event.preventDefault();
    const url = `task/${event.currentTarget.dataset.taskId}`;

    fetch(url, {
      headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
    })
      .then((res) => res.json())
      .then((data) => console.log(data));
  }
}
