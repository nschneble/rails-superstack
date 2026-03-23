class Demo::TerminalCommandDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include SegmentRenderable

  delegate_all

  def rendered_description
    render_segments(object.description)
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
        end
      end
    end, " ")
  end
end
