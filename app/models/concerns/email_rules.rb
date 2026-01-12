module EmailRules
  module_function

  def parse_email(value, domain: nil)
    return nil if value.blank?

    email = EmailNormalizer.call(value)
    return nil unless URI::MailTo::EMAIL_REGEXP.match?(email)

    address = Mail::Address.new(email)
    return nil unless domain.nil? || address.domain =~ domain

    email
  end
end
