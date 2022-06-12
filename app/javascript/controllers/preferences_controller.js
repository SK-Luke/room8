import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = []

  connect() {
    console.log("hello from preferences_controller!")
  }

  color_red(event) {
    //console.log(event);
    const unhappy = event.target
    const id = unhappy.id.split("-")[0]
    unhappy.style.color = "red"
    const neutral = document.getElementById(`${id}-neutral`)
    const happy = document.getElementById(`${id}-happy`)
    neutral.style.color = "black"
    happy.style.color = "black"
  }

  color_orange(event) {
    console.log(event);
    const neutral = event.target
    const id = neutral.id.split("-")[0]
    neutral.style.color = "orange"
    const unhappy = document.getElementById(`${id}-unhappy`)
    const happy = document.getElementById(`${id}-happy`)
    unhappy.style.color = "black"
    happy.style.color = "black"
  }

  color_green(event) {
    console.log(event);
    const happy = event.target
    const id = happy.id.split("-")[0]
    happy.style.color = "green"
    const neutral = document.getElementById(`${id}-neutral`)
    const unhappy = document.getElementById(`${id}-unhappy`)
    neutral.style.color = "black"
    unhappy.style.color = "black"
  }
}
