import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "searchField",
    "searchResults",
  ];
  static values = {
    searchUrl: String,
  };

  connect() {
    const _ = require("lodash");

    this.debouncedSearch = _.debounce((query) => {
      this.searchResultsTarget.innerHTML = "";
      this.searchResultsTarget.append(
        // Show loading spinner
        new DOMParser().parseFromString(
          '<div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div>',
          'text/html'
        ).body
      );
      fetch(
        this.searchUrlValue + `?query=${this.searchFieldTarget.value}`,
        {
          method: "GET",
        }
      ).then ((response) => response.text())
       .then((html) => {
         Turbo.renderStreamMessage(html);
       });
    }, 750);
  }

  searchOnDebounce() {
    this.debouncedSearch(this.searchFieldTarget.value);
  }
}
