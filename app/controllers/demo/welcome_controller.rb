module Demo
  # Builds and renders the demo welcome page with showcase items
  class WelcomeController < DemoApplicationController
    def show
      @items = WelcomeItem.all
        .map { |item| item.with(hidden: item.hidden_for(current_user)) }
        .reject(&:hidden)
        .map(&:decorate)
    end
  end
end
