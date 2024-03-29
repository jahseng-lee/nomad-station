import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "overviewLink",
    "reviewsLink",
    "emergencyInfoLink",
    "visaLink",
  ];

  connect() {
    const pathname = window.location.pathname;
    const pathElements = pathname.split("/")

    if (pathElements.includes("reviews")) {
      this.reviewsLinkTarget.classList.add("active");
    } else if (pathElements.includes("emergency_info")) {
      this.emergencyInfoLinkTarget.classList.add("active");
    } else if (pathElements.includes("visa_information")) {
      this.visaLinkTarget.classList.add("active");
    } else {
      this.overviewLinkTarget.classList.add("active");
    }
  }
}
