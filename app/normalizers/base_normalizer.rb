class BaseNormalizer
  def self.call(...) = new.call(...)

  def call(*args)
    raise NotImplementedError, "This method must be implemented in a subclass"
  end
end
