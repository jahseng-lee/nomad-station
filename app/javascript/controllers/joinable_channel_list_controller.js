import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = [
    "filterQuery",
  ];

  filter() {
    const channelList = document.querySelectorAll('[data-channel-link]');
    const filterQuery = this.filterQueryTarget.value.toUpperCase();

    channelList.forEach((channelLink) => {
      const channelName = channelLink.dataset.channelName;

      if (channelName.toUpperCase().indexOf(filterQuery) > -1) {
        channelLink.style.display = "";
      } else {
        channelLink.style.display = "none";
      }
    });
  }
}
