import { Controller } from "@hotwired/stimulus";
import { csrfToken } from "@rails/ujs";

export default class extends Controller {
  connect() {
    console.log("Yay!! confirm_flatmates_controller is connected!!");
  }
}
