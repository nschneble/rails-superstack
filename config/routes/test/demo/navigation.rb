namespace :demo do
  resources :mac_guffins, only: [ :index ] do
    resource :like, controller: "mac_guffin_likes", only: [ :create, :destroy ]
  end

  get "api",      to: "graphql#show",    as: :api
  get "secrets",  to: "secrets#sssh",   as: :secrets
  get "terminal", to: "terminal#show",  as: :terminal
end
