class FlashController < ApplicationController
  before_action -> { flash.clear }
  after_action  -> { flash.discard }

  def notice
    flash.notice = "Hello, world!"
  end

  def alert
    flash.alert = "Something bad happened"
  end
end
