module Demo
  class PagesController < ApplicationController
    layout "demo/moxie"

    # app/views/demo/mac_guffins.html.erb
    def mac_guffins
      @mac_guffins = Demo::MacGuffin.accessible_by(current_ability)
    end

    # app/views/demo/terminal.html.erb
    def terminal; end

    # app/views/demo/welcome.html.erb
    def welcome; end
  end
end
