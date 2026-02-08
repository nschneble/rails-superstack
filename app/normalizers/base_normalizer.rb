class BaseNormalizer
  def self.call(...) = new.call(...)

  def call(*args)
    raise NotImplementedError, t("errors.method_not_implemented")
  end
end
