class BaseService
  def self.call(...) = new.call(...)

  def call(*)
    raise NotImplementedError, I18n.t("errors.method_not_implemented")
  end
end
