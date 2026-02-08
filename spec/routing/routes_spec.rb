require "rails_helper"

RSpec.describe "Routes loading" do
  it "loads all routes without any errors" do
    expect { Rails.application.reload_routes! }.not_to raise_error
  end

  it "does not include development-only routes in the test environment" do
    Rails.application.reload_routes!

    paths = Rails.application.routes.routes.map do |route|
      route.path.spec.to_s
    end

    expect(paths).not_to include("/sent_mail(.:format)")
  end
end
