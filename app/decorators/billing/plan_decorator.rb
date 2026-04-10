# Formats subscription plan pricing for display in views

class Billing::PlanDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def monthly_price_display
    price = format("%g", price_monthly_cents / 100.0)
    price_display(I18n.t("billing.plans.display.monthly", price:))
  end

  def yearly_price_display
    price = format("%g", price_yearly_cents / 100.0)
    price_display(I18n.t("billing.plans.display.yearly", price:))
  end

  def annual_savings_display
    return if price_monthly_cents.zero?

    percent = ((1 - (price_yearly_cents / (price_monthly_cents * 12).to_f)) * 100).round
    tag.p(I18n.t("billing.plans.display.annual_savings", percent:), class: "mt-1 text-emerald-400 text-sm")
  end

  private

  def price_display(price, separator: "/")
    index = price.index(separator)
    tag.p class: "font-bold text-4xl text-white" do
      safe_join([
        tag.span(price[0, index]),
        tag.span(price[index, price.length], class: "font-normal text-lg text-slate-400")
      ])
    end
  end
end
