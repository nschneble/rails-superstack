# Parses and validates a URL string

class URLParser < BaseParser
  def call(value, scheme: "https", host: nil)
    return nil if value.blank?

    uri = URI.parse(value)
    return nil if uri.scheme != scheme || (host.present? && uri.host !~ host)

    uri
  rescue URI::InvalidURIError
    nil
  end
end
