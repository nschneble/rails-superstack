# Parses and validates an email address string

class EmailParser < BaseParser
  # :reek:TooManyStatements — blank guard, normalize, regex check, parse address, domain filter; each is a distinct validation step
  def call(value, domain: nil)
    return nil if value.blank?

    email = EmailNormalizer.call(value)
    return nil unless URI::MailTo::EMAIL_REGEXP.match?(email)

    address = Mail::Address.new(email)
    return nil if domain.present? && address.domain !~ domain

    email
  end
end
