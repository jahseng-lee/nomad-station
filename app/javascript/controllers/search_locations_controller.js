import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "countrySelect",
    "regionSelect",
    "queryInput",
    "searchForm",
  ];

  regionSelect() {
    this.countrySelectTarget.value = "";
    this.submitSearch();
  }

  submitSearch() {
    this.countrySelectTarget.readOnly = true;
    this.queryInputTarget.readOnly = true;

    // TODO should probably make this a target but
    //      it currently sits outside the controller
    document.getElementById("search-results").innerHTML = this._loadingSpinner();

    this.searchFormTarget.submit();
  }

  _loadingSpinner() {
    return '<div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div>'
  }
}
