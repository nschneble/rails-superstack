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
end
