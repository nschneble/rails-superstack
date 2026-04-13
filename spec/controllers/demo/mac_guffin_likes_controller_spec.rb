require "rails_helper"

RSpec.describe Demo::MacGuffinLikesController, type: :controller do
  include Passwordless::TestHelpers
  include_context "with demo routes"

  let(:owner)       { create(:user) }
  let(:liker)       { create(:user) }
  let(:mac_guffin)  { create(:mac_guffin, user: owner, visibility: :open) }

  describe "POST #create" do
    it "requires authentication" do
      post :create, params: { mac_guffin_id: mac_guffin.id }
      expect(response).to redirect_to(auth_sign_in_path)
    end

    context "when signed in" do
      before { passwordless_sign_in(liker) }

      it "redirects back to the mac_guffins list" do
        allow(Demo::MacGuffinLikes::CreateService).to receive(:call).and_return(ServiceResult.ok(nil))

        post :create, params: { mac_guffin_id: mac_guffin.id }
        expect(response).to redirect_to(demo_mac_guffins_path)
      end

      it "redirects with page and query params when present" do
        allow(Demo::MacGuffinLikes::CreateService).to receive(:call).and_return(ServiceResult.ok(nil))

        post :create, params: { mac_guffin_id: mac_guffin.id, page: 2, q: "cat" }
        expect(response).to redirect_to(demo_mac_guffins_path(page: 2, q: "cat"))
      end

      it "sets a flash alert on failure" do
        allow(Demo::MacGuffinLikes::CreateService).to receive(:call).and_return(
          ServiceResult.fail(:already_liked)
        )

        post :create, params: { mac_guffin_id: mac_guffin.id }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "requires authentication" do
      delete :destroy, params: { mac_guffin_id: mac_guffin.id }
      expect(response).to redirect_to(auth_sign_in_path)
    end

    context "when signed in" do
      before { passwordless_sign_in(liker) }

      it "redirects back to the mac_guffins list" do
        allow(Demo::MacGuffinLikes::DestroyService).to receive(:call).and_return(ServiceResult.ok(nil))

        delete :destroy, params: { mac_guffin_id: mac_guffin.id }
        expect(response).to redirect_to(demo_mac_guffins_path)
      end
    end
  end
end
