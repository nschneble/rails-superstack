class URLValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless URLRules.parse_https_url(value, host: options[:host])
      record.errors.add attribute, (options[:message] || "is not a valid HTTPS url")
    end
  end
end
