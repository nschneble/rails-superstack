class Demo::WelcomeItemDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include SegmentRenderable

  delegate_all

  def rendered_description
    render_segments(object.description)
  end

  def rendered_byline
    render_segments(object.byline)
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
        elsif part.key?(:hidden)
          content_tag(:span, render_segments(part[:hidden]), class: "hidden sm:inline")
        elsif part.key?(:highlight)
          content_tag(:span, part[:highlight], class: "text-amber-200 font-semibold")
        end
      end
    end, " ")
  end
end
