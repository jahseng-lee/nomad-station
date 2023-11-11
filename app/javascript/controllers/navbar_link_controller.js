import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "link",
  ];
  static values = {
    activePaths: Array,
  }

  connect() {
    const firstPath = window.location.pathname.split("/")[1];

    if (this.activePathsValue.includes(firstPath)) {
      this.linkTarget.classList.add("active");
    }
  }
}
