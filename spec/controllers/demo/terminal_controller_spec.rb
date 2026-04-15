require "rails_helper"

RSpec.describe Demo::TerminalController, type: :controller do
  include_context "with demo routes"

  describe "GET #show" do
    it "returns ok" do
      get :show
      expect(response).to have_http_status(:ok)
    end
  end
end
