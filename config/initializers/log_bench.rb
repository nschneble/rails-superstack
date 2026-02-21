return unless Rails.env.development? && defined?(LogBench)

LogBench.setup do |config|
  config.enabled = Rails.env.development?
  config.show_init_message = :none
end
