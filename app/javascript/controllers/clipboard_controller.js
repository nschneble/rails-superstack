import { Controller } from '@hotwired/stimulus';

// connects to data-controller="clipboard"
export default class extends Controller {
	static targets = ['icon', 'tooltip'];
	static values = {
		text: String,
		targetSelector: String,
		duration: { type: Number, default: 1000 },
	};

	async copy(event) {
		event.preventDefault();

		const text = this._resolveText();
		if (!text) return;

		try {
			await navigator.clipboard.writeText(text.trim());
			this._showCopiedIcon();
		} catch (error) {
			console.error('Clipboard copy failed:', error);
		}
	}

	_resolveText() {
		if (this.hasTextValue && this.textValue) return this.textValue;

		if (this.hasTargetSelectorValue) {
			const element = document.querySelector(this.targetSelectorValue);
			if (element) return element.textContent;
		}

		const dataset = this.element.dataset;
		if (dataset.clipboardText) return dataset.clipboardText;

		if (dataset.clipboardTarget) {
			const element = document.querySelector(dataset.clipboardTarget);
			return element?.textContent || '';
		}

		return '';
	}

	_showCopiedIcon() {
		const icon = this.iconTarget;
		const tooltip = this.hasTooltipTarget ? this.tooltipTarget : null;

		icon.classList.add('opacity-0');

		setTimeout(() => {
			icon.classList.remove('fa-copy');
			icon.classList.add('fa-circle-check', 'text-lime-500');
			icon.classList.remove('opacity-0');

			if (tooltip) {
				tooltip.classList.remove('opacity-0', 'translate-y-1');
			}

			setTimeout(() => {
				icon.classList.add('opacity-0');
				if (tooltip) tooltip.classList.add('opacity-0', 'translate-y-1');

				setTimeout(() => {
					icon.classList.remove('fa-circle-check', 'text-lime-500');
					icon.classList.add('fa-copy');
					icon.classList.remove('opacity-0');
				}, 100);
			}, this.durationValue);
		}, 100);
	}
}
