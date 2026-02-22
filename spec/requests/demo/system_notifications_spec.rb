require "rails_helper"

RSpec.describe "System notifications", type: :request do
  it "denies access to non-admin users" do
    user = create(:user)
    passwordless_sign_in(user)

    get demo_system_notifications_path, headers: { HTTP_REFERER: root_path }

    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq("You are not authorized to access this page")
  end

  it "allows admins to send a system notification" do
    admin = create(:user, :admin)
    passwordless_sign_in(admin)
    expect(Turbo::StreamsChannel).to receive(:broadcast_append_to).with(
      "global_toasts",
      hash_including(target: "live-toasts", partial: "shared/live_toast")
    )

    post demo_system_notifications_path,
      params: { system_notification: { message: "Deployment in 5 minutes." } }

    expect(response).to redirect_to(demo_system_notifications_path)
    expect(flash[:notice]).to eq("System notification sent")

    event = SystemNotificationNotifier.last
    expect(event).to be_present
    expect(event.params[:message]).to eq("Deployment in 5 minutes.")
  end

  it "requires a message" do
    admin = create(:user, :admin)
    passwordless_sign_in(admin)

    post demo_system_notifications_path,
      params: { system_notification: { message: " " } }

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Message can&#39;t be blank")
  end

  it "shows a system notification toast to anonymous users once" do
    SystemNotificationNotifier.with(message: "Heads up!").deliver([])

    get root_path
    expect(response.body).to include("Heads up!")

    get root_path
    expect(response.body).not_to include("Heads up!")
  end
end
