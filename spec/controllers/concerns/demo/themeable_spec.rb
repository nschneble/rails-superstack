require "rails_helper"

RSpec.describe Demo::Themeable, type: :controller do
  include Passwordless::TestHelpers
  controller(ApplicationController) do
    include Demo::Themeable # rubocop:disable RSpec/DescribedClass

    def index
      render plain: current_theme.key
    end
  end

  before do
    routes.draw { get "index" => "anonymous#index" }
  end

  describe "#current_theme" do
    context "when the user has no completed purchases" do
      it "returns the default theme" do
        get :index
        expect(response.body).to eq("default")
      end
    end

    context "when the user has completed purchases" do
      it "returns one of the user's purchased themes" do
        user = create(:user)
        purchase = create(:demo_theme_purchase, :completed, user:)
        passwordless_sign_in(user)

        get :index
        expect(response.body).to eq(purchase.theme_key)
      end
    end
  end
end
