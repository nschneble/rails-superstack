require "rails_helper"

RSpec.describe Pom::TabButtonComponent, type: :component do
  it "builds selected tab attributes for the active tab" do
    component = described_class.new(path: "/settings/api", tab: :api, active: true)
    options = component.default_options

    expect(options[:id]).to eq("settings-tab-api")
    expect(options[:aria][:selected]).to be(true)
    expect(options[:aria][:controls]).to eq("settings-panel-api")
  end
end
