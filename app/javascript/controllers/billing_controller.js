import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "monthlyPrice", "yearlyPrice", "monthlyForm", "yearlyForm"]

  connect() {
    this.yearly = false
    this.updateUI()
  }

  toggleInterval() {
    this.yearly = !this.yearly
    this.updateUI()
  }

  updateUI() {
    const isYearly = this.yearly

    this.toggleTarget.classList.toggle("bg-emerald-500", isYearly)
    this.toggleTarget.classList.toggle("bg-slate-600", !isYearly)

    this.monthlyPriceTargets.forEach(el => el.classList.toggle("hidden", isYearly))
    this.yearlyPriceTargets.forEach(el => el.classList.toggle("hidden", !isYearly))

    this.monthlyFormTargets.forEach(el => el.classList.toggle("hidden", isYearly))
    this.yearlyFormTargets.forEach(el => el.classList.toggle("hidden", !isYearly))
  }
}
