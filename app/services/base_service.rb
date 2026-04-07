# Abstract base class for all service objects; subclasses implement #call

class BaseService
  def self.call(...) = new.call(...)

  def call(*)
    raise NotImplementedError, I18n.t("errors.method_not_implemented")
  end
end
