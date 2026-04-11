# Renders welcome item description and byline as mobile-responsive HTML tags

class Demo::WelcomeItemDecorator < ApplicationDecorator
  include Draper::LazyHelpers

  delegate_all

  def rendered_description
    render_segments(object.description)
  end

  def rendered_byline
    render_segments(object.byline)
  end

  private

  def render_segments(segments)
    safe_join(segments.map { |part| render_part(part) }, " ")
  end

  def render_part(part)
    return render_hash(part) if part.is_a? Hash

    part
  end

  def render_hash(part)
    if part.key?(:link)
      link_to part[:link], part[:to].presence || send(part[:route]), class: "hover:text-amber-400 underline!"
    elsif part.key?(:hidden)
      tag.span render_segments(part[:hidden]), class: "hidden sm:inline"
    elsif part.key?(:highlight)
      tag.span part[:highlight], class: "text-amber-200 font-semibold"
    end
  end
end
