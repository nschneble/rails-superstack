require "rails_helper"

RSpec.describe Demo::MacGuffinsController, type: :controller do
  include_context "with demo routes"

  describe "GET #index" do
    it "returns ok" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context "when Typesense is unavailable" do
      before do
        create(:mac_guffin, visibility: :open)
        allow(Demo::MacGuffin).to receive(:search).and_raise(Typesense::Error.new("down"))
      end

      it "still returns ok" do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context "with a turbo frame request" do
      it "renders the search partial" do
        request.headers["Turbo-Frame"] = "mac_guffins_search"
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
