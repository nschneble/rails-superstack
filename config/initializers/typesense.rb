Typesense.configuration = {
  # Typesense Cloud configuration
  # host: "xxx.a1.typesense.net"
  # port: "443"
  # protocol: "https"

  # local machine / self-hosting configuration
  # host: "localhost"
  # port: "8108"
  # protocol: "http"

  nodes: [ {
    host: Figaro.env.typesense_host,
    port: Figaro.env.typesense_port,
    protocol: Figaro.env.typesense_protocol
  } ],

  api_key: Figaro.env.typesense_api_key,
  connection_timeout_seconds: 2,

  # pagination support
  pagination_backend: :pagy,

  # silence messages below this level; options: (:debug, :info, :warn, :error, :fatal)
  log_level: :info
}
