class Demo::FlashController < ApplicationController
  before_action -> { flash.clear }
  after_action  -> { flash.discard }

  layout "demo/moxie"

  # app/views/demo/flash_alert.html.erb
  def alert
    message = "Something bad happened"
    flash.alert = message

    @snippet = sample_code(:alert, message:)
  end

  # app/views/demo/flash_notice.html.erb
  def notice
    message = "Hello, world!"
    flash.notice = message

    @snippet = sample_code(:notice, message:)
  end

  private

  def sample_code(key, message:)
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
