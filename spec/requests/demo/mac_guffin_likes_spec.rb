require "rails_helper"

RSpec.describe "MacGuffin likes", type: :request do
  include ActiveJob::TestHelper

  let(:owner) { create(:user) }
  let(:mac_guffin) { create(:mac_guffin, user: owner) }

  it "requires authentication to like a MacGuffin" do
    post demo_mac_guffin_like_path(mac_guffin)

    expect(response).to redirect_to(auth_sign_in_path)
    expect(Demo::MacGuffinLike.count).to eq(0)
  end

  it "creates a like and notifies the owner" do
    liker = create(:user)
    passwordless_sign_in(liker)
    expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
      [ owner, :toasts ],
      hash_including(target: "live-toasts", partial: "shared/live_toast")
    )

    perform_enqueued_jobs do
      post demo_mac_guffin_like_path(mac_guffin), headers: { HTTP_REFERER: demo_mac_guffins_path }
    end

    expect(response).to redirect_to(demo_mac_guffins_path)
    expect(Demo::MacGuffinLike.count).to eq(1)

    notification = owner.notifications.last
    expect(notification).to be_present
    expect(notification.type).to eq("Demo::MacGuffinLikeNotifier::Notification")
    expect(notification.message).to include(liker.email)
    expect(notification.message).to include(mac_guffin.name)
  end

  it "prevents liking your own MacGuffin" do
    passwordless_sign_in(owner)

    post demo_mac_guffin_like_path(mac_guffin), headers: { HTTP_REFERER: demo_mac_guffins_path }

    expect(response).to redirect_to(demo_mac_guffins_path)
    expect(flash[:alert]).to eq("User can't like your own MacGuffin")
    expect(Demo::MacGuffinLike.count).to eq(0)
  end

  it "removes an existing like" do
    liker = create(:user)
    create(:mac_guffin_like, user: liker, mac_guffin: mac_guffin)
    passwordless_sign_in(liker)

    delete demo_mac_guffin_like_path(mac_guffin), headers: { HTTP_REFERER: demo_mac_guffins_path }

    expect(response).to redirect_to(demo_mac_guffins_path)
    expect(Demo::MacGuffinLike.count).to eq(0)
  end
end
