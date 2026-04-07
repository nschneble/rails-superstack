# ActiveModel validator that rejects invalid email addresses

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless EmailParser.call(value)
      record.errors.add attribute, (options[:message] || "is not an email address")
    end
  end
end
