require "rails_helper"

RSpec.describe "Layouts", type: :request do
  it "disables turbo page caching on the root layout" do
    get root_path

    expect(response.body).to include('<meta name="turbo-cache-control" content="no-cache">')
  end

  it "omits the Font Awesome kit script when not configured" do
    allow(Figaro.env).to receive(:font_awesome_kit_url).and_return(nil)

    get root_path

    expect(response.body).not_to include("kit.fontawesome.com")
  end
end
