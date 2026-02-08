Typesense.configuration = {
  # Typesense Cloud configuration
  # nodes: [{
  #   host: "xxx.a1.typesense.net",
  #   port: "443",
  #   protocol: "https"
  # }],

  # local machine / self-hosting configuration
  nodes: [ {
    host: "localhost",
    port: "8108",
    protocol: "http"
  } ],

  api_key: "xyz",
  connection_timeout_seconds: 2,

  # pagination support
  pagination_backend: :pagy,

  # silence messages below this level; options: (:debug, :info, :warn, :error, :fatal)
  log_level: :info
}
