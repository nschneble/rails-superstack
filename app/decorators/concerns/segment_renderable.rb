module SegmentRenderable
  private

  def render_segments(segments)
    h.safe_join(segments.map do |part|
      case part
      when String
        part
      when Hash
        if part.key?(:link)
          h.link_to part[:link], part[:to], class: "hover:text-amber-400 underline!"
        elsif part.key?(:hidden)
          h.content_tag(:span, render_segments(part[:hidden]), class: "hidden sm:inline")
        elsif part.key?(:highlight)
          h.content_tag(:span, part[:highlight], class: "text-amber-200 font-semibold")
        end
      end
    end, " ")
  end
end
