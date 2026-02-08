Typesense.configuration = {
  # Typesense Cloud configuration
  # host:     "xxx.a1.typesense.net"
  # port:     "443"
  # protocol: "https"

  # local machine / self-hosting configuration
  # host:     "localhost"
  # port:     "8108"
  # protocol: "http"

  nodes: [ {
    host:     ENV.fetch("TYPESENSE_HOST",     "localhost"),
    port:     ENV.fetch("TYPESENSE_PORT",     "8108"),
    protocol: ENV.fetch("TYPESENSE_PROTOCOL", "http")
  } ],

  api_key: ENV.fetch("TYPESENSE_API_KEY", "xyz"),
  connection_timeout_seconds: 2,

  # pagination support
  pagination_backend: :pagy,

  # silence messages below this level; options: (:debug, :info, :warn, :error, :fatal)
  log_level: :info
}
