require "resque"
require "resque/tasks"
require "resque/scheduler/tasks"

task "resque:setup" => :environment do
  # put any app-specific setup here
end
