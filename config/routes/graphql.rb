# a fresh, new GraphQL server designed for Rails

if Rails.env.development?
  get "/graphiql", to: "graphql#graphiql"
  get "/graphql/describe", to: "graphql#describe"
end

post "/graphql", to: "graphql#execute"
