import { Controller } from "@hotwired/stimulus";

// connects to data-controller="redirect"
export default class extends Controller {
  static values = {
    url: String,
    delay: { type: Number, default: 5000 },
  };

  connect() {
    this.timer = setTimeout(() => {
      window.location.href = this.urlValue;
    }, this.delayValue);
  }

  disconnect() {
    clearTimeout(this.timer);
  }
}
