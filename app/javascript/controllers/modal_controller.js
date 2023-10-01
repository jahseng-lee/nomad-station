import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = [
    "modal"
  ];

  connect() {
    // Because we're letting turbo deal with showing a modal, just
    // reveal the modal as soon as it is loaded
    const modal = new Modal(this.modalTarget, {}).show();
  }
}
