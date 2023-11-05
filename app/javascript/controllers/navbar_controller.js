import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "chatLink",
    "exploreLink",
    "profileLink",
  ];

  connect() {
    const firstPath = window.location.pathname.split("/")[1];

    switch(firstPath) {
      case "profile":
        this.profileLinkTarget.classList.add("active");
        break;
      case "chat": case "channels":
        this.chatLinkTarget.classList.add("active");
        break;
      case "search_locations": case "locations": case "":
        this.exploreLinkTarget.classList.add("active");
        break;
    }
  }
}
