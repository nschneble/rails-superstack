import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 10000 },
    duration: { type: Number, default: 200 },
  };

  connect() {
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "-translate-y-4");
      this.element.classList.add("opacity-100", "translate-y-0");
    });

    this._timer = setTimeout(() => this.dismiss(), this.timeoutValue);
  }

  disconnect() {
    if (this._timer) clearTimeout(this._timer);
  }

  dismiss() {
    this.element.classList.add("opacity-0", "-translate-y-4");
    this.element.classList.remove("opacity-100", "translate-y-0");

    setTimeout(() => {
      this.element.remove();
    }, this.durationValue);
  }
}
