require "rails_helper"

RSpec.describe Pom::ButtonComponent, type: :component do
  it "includes disabled styles in default options when disabled" do
    component = described_class.new(path: "/billing/plans", disabled: true)

    expect(component.default_options[:class]).to include("disabled:bg-slate-800/80")
    expect(component.default_options[:disabled]).to be(true)
  end
end
