module Email
  # Initiates an email change request and sends a confirmation email
  class RequestService < BaseService
    def call(user:, new_email:)
      new_email = EmailParser.call(new_email)
      EmailChangeRequest.where(new_email:).expired.delete_all

      return ServiceResult.fail(:invalid) unless new_email.present?

      if User.where(email: new_email).exists? || EmailChangeRequest.where(new_email:).active.exists?
        return ServiceResult.fail(:unavailable)
      end

      request = user.email_change_requests.create!(new_email:)
      UserMailer.with(request:).email_change_confirmation.deliver_later

      ServiceResult.ok(request)
    end
  end
end
