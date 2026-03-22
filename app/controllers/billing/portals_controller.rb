class Billing::PortalsController < AuthenticatedController
  def create
    result = Billing::CreatePortalSessionService.call(
      user: current_user,
      return_url: settings_profile_url
    )

    if result.success?
      redirect_to result.payload.url, allow_other_host: true
    else
      redirect_to settings_profile_path, alert: t("billing.portal.error")
    end
  end
end
