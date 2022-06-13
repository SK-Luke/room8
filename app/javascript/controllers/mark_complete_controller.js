import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["tick"];
  static values = {
    taskid: String,
  };

  connect() {
    console.log("connected");
    console.log(this.tickTarget);
    console.log(this.tickTarget.dataset.value);
  }

  mark(event) {
    event.preventDefault();

    console.log(this.tickTarget.action);
    fetch(`/chore_list/${this.tickTarget.dataset.value}`, {
      method: "PATCH",
      headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
      body: JSON.stringify({ taskid: this.tickTarget.dataset.value }),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
      });
  }
}
