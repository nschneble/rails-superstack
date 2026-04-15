RSpec.shared_context "with demo routes" do
  before do
    Rails.application.routes.draw do
      namespace :demo do
        get  "alert",    to: "flash#alert",            as: :alert
        get  "notice",   to: "flash#notice",            as: :notice
        get  "api",      to: "graphql#show",            as: :api
        get  "secrets",  to: "secrets#sssh",            as: :secrets
        get  "terminal", to: "terminal#show",           as: :terminal
        get  "welcome",  to: "welcome#show",            as: :welcome
        get  "themes",   to: "themes#index",            as: :themes
        post "themes/checkout", to: "themes#checkout", as: :theme_checkout

        resources :mac_guffins, only: [ :index ] do
          resource :like, controller: "mac_guffin_likes", only: [ :create, :destroy ]
        end
      end

      post "/graphql/demo", to: "demo/graphql#execute", as: :graphql_demo

      get "sign_in", to: "sessions#new", as: :auth_sign_in
    end
  end

  after { Rails.application.reload_routes! }
end
