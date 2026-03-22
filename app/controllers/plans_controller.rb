class PlansController < ApplicationController
  def index
    @plans = Billing::Plan::ALL
    @user_subscription = current_user&.subscription
  end
end
