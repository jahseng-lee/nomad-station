import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "exploreLink",
    "profileLink"
  ];

  connect() {
    const pathname = window.location.pathname;

    if (pathname === "/" || pathname === "/search_locations") {
      this.exploreLinkTarget.classList.add("active");
    } else if (pathname === "/profile") {
      this.profileLinkTarget.classList.add("active");
    }
  }
}
