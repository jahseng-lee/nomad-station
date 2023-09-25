import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "searchForm",
  ];

  submitSearch() {
    this.searchFormTarget.submit();
  }
}
