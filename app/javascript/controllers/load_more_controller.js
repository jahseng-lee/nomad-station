import { Controller } from "@hotwired/stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static values = {
    page: Number,
    url: String,
  };

  connect() {
    console.log(this.pageValue);
    console.log(this.urlValue);
  }

  loadMoreMessage() {
    this.pageValue++

    fetch(
      `${this.urlValue}?page=${this.pageValue}`,
      {
        method: "GET",
        credentials: "same-origin",
        headers: { "X-CSRF_Token": Rails.csrfToken() },
        format: "TURBO_STREAM"
      }
    )
      .then((response) => response.text())
      .then((html) => {
        Turbo.renderStreamMessage(html);
      })
  }
}
