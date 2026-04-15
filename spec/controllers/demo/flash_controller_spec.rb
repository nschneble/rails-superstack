require "rails_helper"

RSpec.describe Demo::FlashController, type: :controller do
  include_context "with demo routes"

  describe "GET #alert" do
    it "returns ok" do
      get :alert
      expect(response).to have_http_status(:ok)
    end

    it "sets a flash alert" do
      get :alert
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET #notice" do
    it "returns ok" do
      get :notice
      expect(response).to have_http_status(:ok)
    end

    it "sets a flash notice" do
      get :notice
      expect(flash[:notice]).to be_present
    end
  end
end
