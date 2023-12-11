import { Controller } from "@hotwired/stimulus"
import Pagy from "../pagy-module.js"

export default class extends Controller {
  connect() {
    Pagy.init(this.element);
  }
}
