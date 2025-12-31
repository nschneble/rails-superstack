class MacGuffinsController < ApplicationController
  def index
    @mac_guffins = MacGuffin.visible_to(current_user)
  end
end
