class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless EmailRules.parse_email(value)
      record.errors.add attribute, (options[:message] || "is not an email address")
    end
  end
end
