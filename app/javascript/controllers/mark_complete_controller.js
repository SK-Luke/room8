import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["tick", "chore"];
  static values = {
    taskid: String,
    task: String,
  };

  // connect() {
  //   console.log("connected");
  //   console.log(this.tickTarget);
  //   console.log(this.tickTarget.dataset.value);
  //   console.log(this.choreTarget.dataset.value);
  // }

  mark(event) {
    event.preventDefault();
    // let mark = false;
    console.log(document.getElementById("mark-complete-done"));
    console.log(this.choreTarget.innerText);
    document.querySelector("#exampleModalLabel").innerText =
      this.choreTarget.innerText;
    // console.log(mark);
    document.querySelector("#mark-complete").addEventListener("click", (e) => {
      // mark = true;
      // console.log(mark);
      $("#exampleModal").modal("hide");

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
    });
  }
}
