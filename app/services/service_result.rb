ServiceResult = Data.define(:success?, :payload, :error) do
  def self.ok(payload = nil)
    new(success?: true, payload:, error: nil)
  end

  def self.fail(error, payload = nil)
    new(success?: false, payload:, error:)
  end

  def failure?
    !success?
  end
end
