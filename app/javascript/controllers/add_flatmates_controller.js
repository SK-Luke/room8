import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["lists", "form"];

  connect() {
    console.log("Yay!! add_flatmates controller is connected!");
    // console.log(new FormData(this.formTarget));
  }

  send(event) {
    event.preventDefault();
    console.log("send event triggered");

    fetch(this.formTarget.action, {
      method: "POST",
      headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
      body: new FormData(this.formTarget),
    })
      .then((response) => response.json())
      .then((data) => {
        const htmlLi = `<li style='list-style-type: none; border: 1px solid grey; padding: 4px 8px; margin: 12px 0; color: #888888'>${data.email}</li>`;
        this.listsTarget.insertAdjacentHTML("beforeend", htmlLi);
        this.console.log(data.email);
      });
  }
}
