import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu", "button"];

  connect() {
    this.onUserMouseClick = this.handleUserMouseClick.bind(this);
    this.onUserKeyPress = this.handleUserKeyPress.bind(this);
  }

  disconnect() {
    document.removeEventListener("click", this.onUserMouseClick);
    document.removeEventListener("keydown", this.onUserKeyPress);
  }

  toggle(event) {
    event.preventDefault();
    this.isOpen() ? this.close() : this.open();
  }

  open() {
    this.menuTarget.classList.remove("hidden");

    requestAnimationFrame(() => {
      this.menuTarget.classList.remove(
        "opacity-0",
        "scale-95",
        "-translate-y-1"
      );
      this.menuTarget.classList.add(
        "opacity-100",
        "scale-100",
        "translate-y-0"
      );
    });

    this.buttonTarget.setAttribute("aria-expanded", "true");

    document.addEventListener("click", this.onUserMouseClick);
    document.addEventListener("keydown", this.onUserKeyPress);
  }

  close() {
    if (this.isOpen()) {
      this.menuTarget.classList.add("opacity-0", "scale-95", "-translate-y-1");
      this.menuTarget.classList.remove(
        "opacity-100",
        "scale-100",
        "translate-y-0"
      );

      this.buttonTarget.setAttribute("aria-expanded", "false");
      window.setTimeout(() => this.menuTarget.classList.add("hidden"), 150);

      document.removeEventListener("click", this.onUserMouseClick);
      document.removeEventListener("keydown", this.onUserKeyPress);
    }
  }

  isOpen() {
    return !this.menuTarget.classList.contains("hidden");
  }

  handleUserMouseClick(event) {
    if (!this.element.contains(event.target)) {
      this.close();
    }
  }

  handleUserKeyPress(event) {
    if (event.key === "Escape") {
      this.close();
    }
  }
}
