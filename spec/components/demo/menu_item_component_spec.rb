require "rails_helper"

RSpec.describe Demo::MenuItemComponent, type: :component do
  it "renders the provided label as a menu item link" do
    render_inline(described_class.new(path: "/demo/secrets", icon: "lock", label: "Secret menu"))

    expect(rendered_content).to include('role="menuitem"')
    expect(rendered_content).to include("Secret menu")
  end

  it "renders secret theme styles when configured" do
    component = described_class.new(path: "/demo/secrets", icon: "lock", theme: :secret)

    expect(component.send(:html_options)[:class]).to include("text-pink-600")
  end
end
