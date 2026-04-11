# Parses and validates a URL string

class URLParser < BaseParser
  def call(value, scheme: "https", host: nil)
    @uri = URI.parse(value)
    return nil if wrong_scheme?(scheme) || wrong_host?(host)

    @uri
  rescue URI::InvalidURIError
    nil
  end

  private

  def wrong_scheme?(scheme)
    @uri.scheme != scheme
  end

  def wrong_host?(host)
    host.present? && @uri.host !~ host
  end
end
