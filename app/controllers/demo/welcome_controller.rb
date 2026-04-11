module Demo
  # Builds and renders the demo welcome page with showcase items
  class WelcomeController < DemoApplicationController
    def show
      @items = WelcomeItem.all
        .select { |item| show_welcome_item?(item) }
        .map(&:decorate)
    end

    private

    def show_welcome_item?(item)
      item.always_visible? ||
        (item.visibility == "anonymous" && current_user.blank?) ||
        (item.visibility == "user" && current_user.present?)
    end
  end
end
