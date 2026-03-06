class URLParser < BaseParser
  def call(value, scheme: "https", host: nil)
    return nil if value.blank?

    uri = URI.parse(value)

    return nil unless uri.scheme == scheme
    return nil unless host.nil? || uri.host =~ host

    uri
  rescue URI::InvalidURIError
    nil
  end
end
