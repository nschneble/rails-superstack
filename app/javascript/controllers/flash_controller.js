import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="flash"
export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 10000 },
    duration: { type: Number, default: 200 },
    notificationId: { type: Number, default: 0 },
  };

  connect() {
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "-translate-y-4");
      this.element.classList.add("opacity-100", "translate-y-0");
    });

    this._timer = setTimeout(() => this.dismiss(), this.timeoutValue);

    if (this.notificationIdValue > 0) {
      const oneYear = 365 * 24 * 60 * 60;
      document.cookie = `global_notification_id=${this.notificationIdValue}; path=/; max-age=${oneYear}; SameSite=Lax`;
    }
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
