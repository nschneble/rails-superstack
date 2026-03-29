class Demo::Themes::ThemeDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def price_display
    format("$%.2f", price_cents / 100.0)
  end

  def rendered_image_attribution
    render_segments(object.image_attribution)
  end

  private

  def render_segments(segments)
    safe_join(segments.map do |part|
      case part
      when String
        part
      when Hash
        if part.key?(:link)
          link_to part[:link], part[:to], class: "hover:text-amber-400 underline!"
        end
      end
    end, " ")
  end
end
