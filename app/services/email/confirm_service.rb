# Validates an email change token and updates the user's email address

class Email::ConfirmService < BaseService
  def call(token:)
    @request = EmailChangeRequest.find_by!(token:)

    raise ServiceError, "link_expired" if @request.expired?
    raise ServiceError, "unavailable"  if email_unavailable?

    update_email
  rescue ServiceError => error
    @request.destroy
    ServiceResult.fail(error.message)
  rescue ActiveRecord::RecordNotFound
    ServiceResult.fail("invalid_link")
  end

  private

  def email
    @request.new_email
  end

  def email_unavailable?
    User.where(email:).where.not(id: @request.user_id).exists?
  end

  def update_email
    user = @request.user
    user.update!(email:, email_confirmed_at: Time.current)
    user.email_change_requests.delete_all
    ServiceResult.ok(user)
  end
end
