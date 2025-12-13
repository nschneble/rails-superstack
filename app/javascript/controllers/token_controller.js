import { Controller } from '@hotwired/stimulus';

// connects to data-controller="token"
export default class extends Controller {
	static targets = ['input', 'button'];

	submit(event) {
		event.requestSubmit();

		this.inputTarget.setAttribute('disabled', 'disabled');
		this.buttonTarget.setAttribute('disabled', 'disabled');
	}
}
