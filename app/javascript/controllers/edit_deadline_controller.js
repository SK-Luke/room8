import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["edit", "form", "formDets"];

  // connect() {
  //   console.log("connected");
  //   // console.log(this.formTarget.getElementsByClassName("d-flex")[0].classList);
  //   console.log(this.formDetsTarget);
  //   console.log(this.element.outerHTML);
  // }

  openForm(event) {
    event.preventDefault();
    // console.log(event)
    this.formTarget.classList.remove("d-none");
    this.formTarget
      .getElementsByClassName("d-flex")[0]
      .classList.remove("d-flex");
    // this.formTarget
    //   .getElementsByClassName("d-flex")[0]
    //   .classList.add("d-flex.flex-column");
  }

  send(event) {
    event.preventDefault();

    fetch(this.formDetsTarget.action, {
      method: "POST",
      headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
      body: new FormData(this.formDetsTarget),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        location.reload();
      });
  }
}
