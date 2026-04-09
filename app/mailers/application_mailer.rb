# Base mailer with shared defaults

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
