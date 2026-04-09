# Abstract base class for all parser objects; subclasses implement #call

class BaseParser
  def self.call(...) = new.call(...)

  def call(*_args)
    raise NotImplementedError, t("errors.method_not_implemented")
  end
end
