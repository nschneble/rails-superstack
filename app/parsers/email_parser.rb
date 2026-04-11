# Parses and validates an email address string

class EmailParser < BaseParser
  def call(value, domain: nil)
    @email = EmailNormalizer.call(value)
    return nil if bad_email? || wrong_domain?(domain)

    @email
  end

  private

  def bad_email?
    URI::MailTo::EMAIL_REGEXP !~ @email
  end

  def wrong_domain?(domain)
    domain.present? && Mail::Address.new(@email).domain !~ domain
  end
end
