import { Controller } from '@hotwired/stimulus';

// connects to data-controller="email"
export default class extends Controller {
	static targets = ['input', 'button'];

	toggle({ params: { currentEmail } }) {
		const newEmail = this.inputTarget.value.toLowerCase().trim();
		if (newEmail === currentEmail) {
			this.buttonTarget.setAttribute('disabled', 'disabled');
		} else {
			this.buttonTarget.removeAttribute('disabled');
		}
	}

	submit(event) {
		event.requestSubmit();

		this.inputTarget.setAttribute('disabled', 'disabled');
		this.buttonTarget.setAttribute('disabled', 'disabled');
	}
}
