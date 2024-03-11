import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Apply `.is-active` class to all relevant tags
    const params = new URLSearchParams(window.location.search);
    const filterParams = params.get("filter");
    if (!!filterParams) {
      document
        .querySelectorAll("[data-location-badge]")
        .forEach((link) => {
          if (filterParams.split(",").includes(link.dataset.tagValue)) {
            link.classList.add("is-active");
          }
        });
    }
  }
}
