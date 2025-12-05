import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
	static targets = ['input', 'button'];

	submit(event) {
		event.requestSubmit();

		this.inputTarget.setAttribute('disabled', 'disabled');
		this.buttonTarget.setAttribute('disabled', 'disabled');
	}
}
