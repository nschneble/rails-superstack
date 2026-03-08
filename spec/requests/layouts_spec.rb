require "rails_helper"

RSpec.describe "Layouts", type: :request do
  it "disables turbo page caching on the root layout" do
    get root_path

    expect(response.body).to include('<meta name="turbo-cache-control" content="no-cache">')
  end
end
