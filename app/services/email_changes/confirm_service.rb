module EmailChanges
  class ConfirmService < BaseService
    def call(token:)
      request = EmailChangeRequest.find_by!(token:)

      if request.expired?
        request.destroy
        return ServiceResult.fail(:link_expired)
      end

      if User.where(email: request.new_email).where.not(id: request.user_id).exists?
        request.destroy
        return ServiceResult.fail(:unavailable)
      end

      request.user.update!(email: request.new_email, email_confirmed_at: Time.current)
      request.user.email_change_requests.delete_all

      ServiceResult.ok(request.user)
    end
  end
end
