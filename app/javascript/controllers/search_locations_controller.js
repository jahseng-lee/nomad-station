import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "countrySelect",
    "regionSelect",
    "searchForm",
  ];

  regionSelect() {
    console.log(this.countrySelectTarget);
    this.countrySelectTarget.value = "";
    this.submitSearch();
  }

  submitSearch() {
    this.searchFormTarget.submit();
  }
}
