import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "countrySelect",
    "filter",
    "regionSelect",
    "queryInput",
    "searchForm",
  ];

  connect() {
    // Set any existing filters in the form
    const params = new URLSearchParams(window.location.search);
    const filterParams = params.get("filter");
    if (!!filterParams) {
      // Set the values in the hidden form...
      this.filterTarget.value = filterParams;

      // ... then make sure it's obvious the filter is applied
      document
        .querySelectorAll("[data-tag-filter-link]")
        .forEach((link) => {
          if (filterParams.split(",").includes(link.dataset.tagValue)) {
            link.classList.add("is-active");
          }
        });
    }
  }

  filterByTag(e) {
    this._showLoadingSpinner();

    let tagFilterValue = e.target.dataset.tagValue;
    if (!tagFilterValue) {
      // Clicking on the icon within the link doesn't work.
      // In that case, grab the parent (the actual link) and use that
      tagFilterValue = e.target.parentElement.dataset.tagValue;
    }

    if (
      !!this.filterTarget.value
    ) {
      // Append the filter values if they exist and is not already filtered on...
      if (
        !this.filterTarget.value.split(",").includes(tagFilterValue)
      ) {
        this.filterTarget.value += `,${tagFilterValue}`;
      } else {
        // Remove the filter
        this.filterTarget.value = this
          .filterTarget
          .value
          .split(",")
          .filter((filterValue) => filterValue != tagFilterValue)
          .join(",");
      }
    } else {
      //... or just set the value
      this.filterTarget.value = tagFilterValue;
    }

    this.submitSearch();
  }

  regionSelect() {
    this.countrySelectTarget.value = "";
    this.submitSearch();
  }

  submitSearch() {
    this.countrySelectTarget.readOnly = true;
    this.queryInputTarget.readOnly = true;

    this._showLoadingSpinner();

    this.searchFormTarget.submit();
  }

  _showLoadingSpinner() {
    // TODO should probably make this a target but
    //      it currently sits outside the controller
    document.getElementById("search-results").innerHTML = this._loadingSpinner();
  }

  _loadingSpinner() {
    return '<div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div>';
  }
}
