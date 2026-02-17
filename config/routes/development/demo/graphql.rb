# demo GraphQL schema and endpoints
get  "/demo/graphiql",         to: "graphql/demo/mac_guffins#graphiql"
get  "/demo/graphql/describe", to: "graphql/demo/mac_guffins#describe"
post "/demo/graphql",          to: "graphql/demo/mac_guffins#execute"
