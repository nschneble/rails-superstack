module Email
  # Initiates an email change request and sends a confirmation email
  class RequestService < BaseService
    # :reek:TooManyStatements — parse email, clean expired requests, guard invalid/unavailable, create request, send mailer; each step is required
    def call(user:, new_email:)
      new_email = EmailParser.call(new_email)
      requests = EmailChangeRequest.where(new_email:)
      requests.expired.delete_all

      return ServiceResult.fail(:invalid) unless new_email.present?

      if User.where(email: new_email).exists? || requests.active.exists?
        return ServiceResult.fail(:unavailable)
      end

      request = user.email_change_requests.create!(new_email:)
      UserMailer.with(request:).email_change_confirmation.deliver_later

      ServiceResult.ok(request)
    end
  end
end
