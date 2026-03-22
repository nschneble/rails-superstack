class Demo::TerminalCommandDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include SegmentRenderable
  delegate_all

  def rendered_description
    render_segments(object.description)
  end
end
