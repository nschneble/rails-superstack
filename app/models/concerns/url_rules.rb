module UrlRules
  module_function

  def parse_https_url(value, host: nil)
    return nil if value.blank?

    uri = URI.parse(value)

    return nil unless uri.scheme == "https"
    return nil unless host.nil? || uri.host =~ host

    uri
  rescue URI::InvalidURIError
    nil
  end
end
