# a fresh, new GraphQL server designed for Rails
get  "/graphiql",         to: "graphql/users#graphiql"
get  "/graphql/describe", to: "graphql/users#describe"
post "/graphql",          to: "graphql/users#execute"
post "/graphql/health",   to: "graphql/health#execute"
