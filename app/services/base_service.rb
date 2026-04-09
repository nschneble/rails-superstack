# Abstract base class for all service objects; subclasses implement #call

class BaseService
  def self.call(...) = new.call(...)

  def call(*)
    raise NotImplementedError, I18n.t("errors.method_not_implemented")
  end

  private

  def log_error_and_fail(error, message)
    Rails.logger.error(self.class) { message }
    ServiceResult.fail(error, message)
  end
end
