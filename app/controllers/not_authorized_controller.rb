class NotAuthorizedController < AuthenticatedController
  def denied
    raise User::NotAuthorized
  end
end
