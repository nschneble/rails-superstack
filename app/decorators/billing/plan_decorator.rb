class Billing::PlanDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def monthly_price_display
    return free_price_display if price_monthly_cents.zero?

    price = format("%g", price_monthly_cents / 100.0)
    price_display(I18n.t("billing.plans.display.monthly", price:))
  end

  def yearly_price_display
    return free_price_display if price_yearly_cents.zero?

    price = format("%g", price_yearly_cents / 100.0)
    price_display(I18n.t("billing.plans.display.yearly", price:))
  end

  def annual_savings_display
    percent = (1 - (price_yearly_cents / (price_monthly_cents * 12))) * 100
    content_tag(:p, I18n.t("billing.plans.display.annual_savings", percent:), class: "text-sm text-emerald-400 mt-1")
  end

  private

  def free_price_display
    content_tag(:p, I18n.t("billing.plans.display.free"), class: "font-bold text-4xl text-white")
  end

  def price_display(price, separator: "/")
    content_tag(:p, class: "font-bold text-4xl text-white") do
      safe_join([
        content_tag(:span, price[0, price.index(separator)]),
        content_tag(:span, price[price.index(separator), price.length], class: "font-normal text-lg text-slate-400")
      ])
    end
  end
end
