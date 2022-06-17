import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";
import { initFlatpickr } from "../plugins/flatpickr";

export default class extends Controller {
  static targets = ["edit", "form", "formDets"];

  // connect() {
  //   console.log(document.querySelector("#edit-form"));
  //   document
  //     .querySelector(".edit-close")
  //     .addEventListener("click", (e) => console.log("clicked"));
  // }

  openForm() {
    console.log(document.querySelector("#edit-close"));
    document
      .querySelector("#edit-close")
      .addEventListener("click", (e) => console.log(e));

    console.log(document.querySelector("#edit-form"));
    document.querySelector("#edit-form").classList.add("open");
  }

  closeForm(event) {
    event.preventDefault();

    document
      .querySelector("#edit-close")
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
      .then((data) => {
        const form = document.querySelector("#edit-form");
        console.log(data.form);
        form.innerHTML = data.form;
        form
          .querySelector("#edit-close")
          .addEventListener("click", this.closeForm);
        initFlatpickr();

        this.openForm();
      });
  }
}
