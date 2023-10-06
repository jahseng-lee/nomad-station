import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "countrySelect",
    "regionSelect",
    "queryInput",
    "searchForm",
  ];

  connect() {
    this._autoFocusInput();
  }

  regionSelect() {
    this.countrySelectTarget.value = "";
    this.submitSearch();
  }

  submitSearch() {
    this.countrySelectTarget.readOnly = true;
    this.queryInputTarget.readOnly = true;

    this.searchFormTarget.submit();
  }

  _autoFocusInput() {
    const end = this.queryInputTarget.value.length;

    this.queryInputTarget.setSelectionRange(end, end);
    this.queryInputTarget.focus();
  }
}
