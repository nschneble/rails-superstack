SimpleCov::Badger.configure do |config|
  config.run_if = -> { `git rev-parse --abbrev-ref HEAD` == "main\n" }
  config.token = Figaro.env.simplecov_badger_token
end
