import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  static targets = ["lists", "form", "alert", "li"];
  static values = {
    flatid: String
  }

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

  remove(event) {
    event.preventDefault();
    console.log("x event triggered");

    const li = this.liTarget;
    console.log(li);
    li.parentNode.removeChild(li);
  }

  async destroyPreset(event) {
    event.preventDefault();
    console.log(event)
    console.log(event.target.id)
    const chores_to_delete = event.target.id.split(" ")

    await Promise.all(
      chores_to_delete.map(async id => {
        const url = `/flats/${this.flatidValue}/chores/${id}`

        await fetch(url, {
          method: "DELETE",
          headers: {
              'Content-Type': 'application/json',
              // 'Accept': 'application/json',
              'X-CSRF-Token': csrfToken()
          }
        })
      })
    )
    window.location.href = `/flats/${this.flatidValue}/setup_chores`
  }
}
