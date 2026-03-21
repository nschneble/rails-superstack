require "rails_helper"

RSpec.describe "Global notifications", type: :request do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  it "denies access to non-admin users" do
    user = create(:user)
    passwordless_sign_in(user)

    get notifications_path, headers: { HTTP_REFERER: root_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("You are not authorized to access this resource")
  end

  it "allows admins to send a global notification" do
    admin = create(:user, :admin)
    passwordless_sign_in(admin)
    expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
      "global_notifications",
      hash_including(target: "notifications", partial: "shared/notification")
    )

    perform_enqueued_jobs do
      post notifications_path,
        params: { global_notification: { message: "Deployment in 5 minutes." } }
    end

    expect(response).to redirect_to(notifications_path)
    expect(flash[:notice]).to eq("Notification sent")

    event = NewGlobalNotificationNotifier.last
    expect(event).to be_present
    expect(event.params[:message]).to eq("Deployment in 5 minutes.")
  end

  it "requires a message" do
    admin = create(:user, :admin)
    passwordless_sign_in(admin)

    post notifications_path,
      params: { global_notification: { message: " " } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Message can&#39;t be blank")
  end

  it "shows a global notification toast to anonymous users once" do
    NewGlobalNotificationNotifier.with(message: "Heads up!").deliver([])

    get root_path
    expect(response.body).to include("Heads up!")

    get root_path
    expect(response.body).not_to include("Heads up!")
  end

  it "does not show stale global notifications" do
    travel_to 11.minutes.ago do
      NewGlobalNotificationNotifier.with(message: "Old news").deliver([])
    end

    get root_path

    expect(response.body).not_to include("Old news")
  end
end
