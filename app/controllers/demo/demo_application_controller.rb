module Demo
  # Base controller for all demo pages
  class DemoApplicationController < ::ApplicationController
    include Themeable

    layout "demo/moxie"
  end
end
