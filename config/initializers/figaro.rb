# CI and test runs don't need Typesense
return if Rails.env.test? || ENV["CI"].present?

Figaro.require_keys(
  "typesense_api_key",
  "typesense_host",
  "typesense_port",
  "typesense_protocol"
)
