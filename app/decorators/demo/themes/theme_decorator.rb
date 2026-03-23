class Demo::Themes::ThemeDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def price_display
    format("$%.2f", price_cents / 100.0)
  end
end
