module Demo
  class DemoApplicationController < ::ApplicationController
    include Themeable

    layout "demo/moxie"
  end
end
