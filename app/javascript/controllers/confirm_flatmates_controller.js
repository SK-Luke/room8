import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Yay!! confirm_flatmates_controller is connected!!");
  }

  click(event) {
    console.log("I can cliick");

    if (user) {
      console.log(event);
    }
  }
}
