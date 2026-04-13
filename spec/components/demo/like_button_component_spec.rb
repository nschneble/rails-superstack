require "rails_helper"

RSpec.describe Demo::LikeButtonComponent, type: :component do
  it "renders a delete button for selected likes" do
    render_inline(described_class.new(path: "/demo/mac_guffins/1/like", selected: true, count: 2))

    expect(rendered_content).to include('method="post"')
    expect(rendered_content).to include('name="_method"')
    expect(rendered_content).to include('value="delete"')
    expect(rendered_content).to include(">2<")
  end

  it "renders a disabled button when requested" do
    render_inline(described_class.new(path: "/demo/mac_guffins/1/like", disabled: true))

    expect(rendered_content).to include("disabled")
  end
end
