import { Controller } from "@hotwired/stimulus";
import Choices from "choices.js";

export default class extends Controller {
  static targets = [
    "select"
  ];

  connect() {
    new Choices(this.selectTarget);
  }
}
