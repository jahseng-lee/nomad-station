import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "chatLink",
    "exploreLink",
    "profileLink",
  ];

  connect() {
    const pathname = window.location.pathname;

    switch(pathname) {
      case "/profile":
        this.profileLinkTarget.classList.add("active");
        break;
      case "/chat":
        this.chatLinkTarget.classList.add("active");
        break;
      default:
        // "/" or "/search_locations"
        this.exploreLinkTarget.classList.add("active");
    }
  }
}
