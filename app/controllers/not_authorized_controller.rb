class NotAuthorizedController < ApplicationController
  before_action :authenticate_user!

  def denied
    raise User::NotAuthorized
  end
end
