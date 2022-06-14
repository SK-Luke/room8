import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["lists", "form", "alert"];

  connect() {
    console.log("Yay!! add_flatmates controller is connected!");
    // console.log(new FormData(this.formTarget));
  }

  send(event) {
    event.preventDefault();
    // console.log("send event triggered");

    fetch(this.formTarget.action, {
      method: "POST",
      headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
      body: new FormData(this.formTarget),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        if (data.inserted_item) {
          this.listsTarget.insertAdjacentHTML("beforeend", data.inserted_item);
          document.getElementById("confirm_btn").disabled = false;
          this.alertTarget.innerHTML = "";
        } else {
          this.alertTarget.innerHTML =
            "<span class='text-danger'>User email not found</span>";
        }
        this.formTarget.outerHTML = data.form;
      });
  }
}
