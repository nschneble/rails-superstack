class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_email_change_request

  def show
    if @request.present?
      flash.notice = "We've sent a confirmation link to #{@request.new_email}"
      flash.discard
    end
  end

  private

  def check_for_email_change_request
    @request ||= EmailChangeRequest.latest_active_for(current_user)
  end
end
