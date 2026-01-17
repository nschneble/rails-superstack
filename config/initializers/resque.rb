require "resque"
require "resque/server"
require "resque/scheduler"
require "resque/scheduler/server"

redis_url = ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0")
Resque.redis = redis_url

# loads the schedule for resque-scheduler only when explicitly enabled
if ENV["RESQUE_SCHEDULE_ENABLED"] == "1"
  schedule_file = Rails.root.join("config", "resque_schedule.yml")
  if File.exist?(schedule_file)
    Resque.schedule = YAML.safe_load(File.read(schedule_file), aliases: true)
  end
end
