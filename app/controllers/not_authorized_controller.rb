# Raises NotAuthorized to trigger access-denied handling for restricted routes

class NotAuthorizedController < AuthenticatedController
  def denied
    raise User::NotAuthorized, t("super_admin.flash.access_denied")
  end
end
