if Rails.env.development?
  namespace :demo do
    get "api", to: "graphql#show", as: :api
  end

  # a fresh, new GraphQL server designed for Rails
  post "/graphql/demo", to: "demo/graphql#execute"
end
