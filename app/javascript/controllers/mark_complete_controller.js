import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["tick", "chore"];
  static values = {
    taskid: String,
  };

  // connect() {
  //   console.log("connected");
  //   console.log(this.tickTarget);
  //   console.log(this.tickTarget.dataset.value);
  //   console.log(this.choreTarget.dataset.value);
  // }

  mark(event) {
    event.preventDefault();
    if (confirm(`Have you ${this.choreTarget.dataset.value}?`)) {
      fetch(`/chore_list/${this.tickTarget.dataset.value}`, {
        method: "PUT",
        headers: { Accept: "application/json", "X-CSRF-Token": csrfToken() },
        body: JSON.stringify({ taskid: this.tickTarget.dataset.value }),
      })
        .then((response) => response.json())
        .then((data) => {
          console.log(data);
          location.reload();
        });
    }
  }
}
