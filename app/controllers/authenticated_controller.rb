# Base controller that requires all requests to be authenticated

class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
end
