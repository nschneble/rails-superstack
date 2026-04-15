require "rails_helper"

RSpec.describe Demo::VisibilityComponent, type: :component do
  it "renders the visibility label" do
    render_inline(described_class.new(visibility: "admin"))

    expect(rendered_content).to include("admin")
    expect(rendered_content).to include("fa-eye")
  end
end
