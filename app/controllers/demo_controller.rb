class DemoController < ApplicationController
  before_action -> { flash.clear   }, only: %i[flash_alert flash_notice]
  after_action  -> { flash.discard }, only: %i[flash_alert flash_notice]

  layout "demo"

  # app/views/demo/flash_alert.html.erb
  def flash_alert
    message = "Something bad happened"
    flash.alert = message

    @snippet = flash_sample_code(:alert, message:)
  end

  # app/views/demo/flash_notice.html.erb
  def flash_notice
    message = "Hello, world!"
    flash.notice = message

    @snippet = flash_sample_code(:notice, message:)
  end

  # app/views/demo/mac_guffins.html.erb
  def mac_guffins
    @mac_guffins = Demo::MacGuffin.accessible_by(current_ability)
  end

  # app/views/demo/secrets.html.erb
  def secrets
    return if Flipper.enabled?(:secrets, current_user)
    raise ActionController::RoutingError

    # a "secret" route gated behind a feature flag
  end

  # app/views/demo/terminal.html.erb
  def terminal; end

  # app/views/demo/welcome.html.erb
  def welcome; end

  private

  def flash_sample_code(key, message:)
    snippet = <<~CODE
      class YourController < ApplicationController
        def index
          flash.#{key} = "#{message}"
          # ...
        end
      end
    CODE

    code = helpers.highlight_syntax(snippet)
    code.sub("<pre ", "<pre class=\"mt-8 p-4 rounded-sm shadow-slate-600 shadow-xl\" ").html_safe
  end
end
