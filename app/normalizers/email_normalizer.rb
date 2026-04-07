# Strips, downcases, and compacts whitespace from an email address string

class EmailNormalizer < BaseService
  def call(email)
    email.to_s.strip.downcase.gsub(/\s+/, "")
  end
end
