import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = [
    "textarea"
  ];

  resizeTextarea() {
    this.textareaTarget.rows = this.textareaTarget.value.split("\n").length;
  }
}
