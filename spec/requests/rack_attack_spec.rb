require "rails_helper"

RSpec.describe "Rack::Attack throttling", type: :request do
  around do |example|
    original_enabled = Rack::Attack.enabled
    original_store = Rack::Attack.cache.store

    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

    example.run

    Rack::Attack.enabled = original_enabled
    Rack::Attack.cache.store = original_store
  end

  it "throttles repeated sign-in attempts from the same IP" do
    5.times { post auth_sign_in_path, params: { passwordless: { email: "throttle-ip@example.com" } } }
    expect(response).not_to have_http_status(:too_many_requests)

    post auth_sign_in_path, params: { passwordless: { email: "throttle-ip@example.com" } }
    expect(response).to have_http_status(:too_many_requests)
  end

  it "throttles repeated sign-in attempts for the same email regardless of casing" do
    5.times { post auth_sign_in_path, params: { passwordless: { email: "Throttle-Email@Example.com" } }, headers: { "REMOTE_ADDR" => "10.0.0.1" } }
    post auth_sign_in_path, params: { passwordless: { email: "throttle-email@example.com" } }, headers: { "REMOTE_ADDR" => "10.0.0.2" }

    expect(response).to have_http_status(:too_many_requests)
  end

  it "throttles repeated GraphQL requests from the same IP" do
    30.times { post "/graphql", params: { query: "{ health { status } }" } }
    expect(response).not_to have_http_status(:too_many_requests)

    post "/graphql", params: { query: "{ health { status } }" }
    expect(response).to have_http_status(:too_many_requests)
  end

  it "returns a plain-text response, not the vendored super_admin engine's JSON responder" do
    5.times { post auth_sign_in_path, params: { passwordless: { email: "throttle-responder@example.com" } } }
    post auth_sign_in_path, params: { passwordless: { email: "throttle-responder@example.com" } }

    expect(response).to have_http_status(:too_many_requests)
    expect(response.content_type).to start_with("text/plain")
    expect(response.body).to eq("Too many requests. Please try again later.\n")
  end
end
