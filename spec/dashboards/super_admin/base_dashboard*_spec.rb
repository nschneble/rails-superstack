require "rails_helper"

RSpec.describe SuperAdmin::BaseDashboard do
  it "loads the shipped dashboard classes" do
    expect(SuperAdmin::ApiTokenDashboard < described_class).to be(true)
    expect(SuperAdmin::EmailChangeRequestDashboard < described_class).to be(true)
    expect(SuperAdmin::UserDashboard < described_class).to be(true)
    expect(SuperAdmin::Demo::MacGuffinDashboard < described_class).to be(true)
    expect(SuperAdmin::Demo::MacGuffinLikeDashboard < described_class).to be(true)
  end
end
