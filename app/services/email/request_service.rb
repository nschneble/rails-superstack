module Email
  # Initiates an email change request and sends a confirmation email
  class RequestService < BaseService
    def call(user:, new_email:)
      new_email = EmailParser.call(new_email)
      raise ServiceError, "invalid" unless new_email.present?

      validate_email_request(new_email:)
      ServiceResult.ok(create_request(user:, new_email:))
    rescue ServiceError => error
      ServiceResult.fail(error.message)
    end

    private

    def validate_email_request(new_email:)
      requests = EmailChangeRequest.where(new_email:)
      requests.expired.delete_all

      if User.where(email: new_email).exists? || requests.active.exists?
        raise ServiceError, "unavailable"
      end
    end

    def create_request(user:, new_email:)
      request = user.email_change_requests.create!(new_email:)
      UserMailer.with(request:).email_change_confirmation.deliver_later
      request
    end
  end
end
