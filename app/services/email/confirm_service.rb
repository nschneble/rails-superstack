module Email
  # Validates an email change token and updates the user's email address
  class ConfirmService < BaseService
    # :reek:TooManyStatements — find request, expire guard, extract email, uniqueness guard, extract user, update, delete requests, return
    def call(token:)
      request = EmailChangeRequest.find_by!(token:)
      return destroy_and_fail(request, :link_expired) if request.expired?

      new_email = request.new_email
      return destroy_and_fail(request, :unavailable) if User.where(email: new_email).where.not(id: request.user_id).exists?

      user = request.user
      user.update!(email: new_email, email_confirmed_at: Time.current)
      user.email_change_requests.delete_all
      ServiceResult.ok(user)
    end

    private

    def destroy_and_fail(request, code)
      request.destroy
      ServiceResult.fail(code)
    end
  end
end
