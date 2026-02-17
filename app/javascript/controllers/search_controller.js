import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static values = { delay: { type: Number, default: 250 } };

  connect() {
    this.submitTimeout = null;
    this.frameLoadHandler = (event) => this.handleFrameLoad(event);
    document.addEventListener("turbo:frame-load", this.frameLoadHandler);
    this.queueFocusAtEnd();
  }

  disconnect() {
    this.clearPendingSubmit();
    document.removeEventListener("turbo:frame-load", this.frameLoadHandler);
  }

  submit() {
    this.clearPendingSubmit();
    this.submitTimeout = setTimeout(
      () => this.element.requestSubmit(),
      this.delayValue
    );
  }

  clearPendingSubmit() {
    if (!this.submitTimeout) return;

    clearTimeout(this.submitTimeout);
    this.submitTimeout = null;
  }

  handleFrameLoad(event) {
    if (event.target.id !== this.frameId()) return;
    this.queueFocusAtEnd();
  }

  restoreFocus() {
    this.queueFocusAtEnd();
  }

  frameId() {
    return this.element.dataset.turboFrame;
  }

  focusInputAtEnd() {
    const input = this.element.querySelector(
      'input[type="search"], input[name="q"]'
    );
    if (!input) return;

    const position = input.value.length;
    input.focus();

    if (typeof input.setSelectionRange === "function") {
      input.setSelectionRange(position, position);
    }
  }

  queueFocusAtEnd() {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => this.focusInputAtEnd());
    });
  }
}
