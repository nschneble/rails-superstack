# a fresh, new GraphQL server designed for Rails
get  "/graphiql",         to: "graphql/base#graphiql"
get  "/graphql/describe", to: "graphql/base#describe"
post "/graphql",          to: "graphql/base#execute"
