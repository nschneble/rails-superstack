class EmailNormalizer < BaseService
  def call(email)
    email.to_s.strip.downcase.gsub(/\s+/, "")
  end
end
