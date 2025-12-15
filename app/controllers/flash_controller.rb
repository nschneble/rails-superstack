class FlashController < ApplicationController
  before_action -> { flash.clear }
  after_action  -> { flash.discard }

  def notice
    flash.notice = "Something just succeeded with a very long message"
  end

  def alert
    flash.alert = "Something just failed… badly"
  end
end
