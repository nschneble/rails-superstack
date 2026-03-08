# a fresh, new GraphQL server designed for Rails

get "/graphiql", to: "graphql#graphiql"
get "/graphql/describe", to: "graphql#describe"

post "/graphql", to: "graphql#execute"
