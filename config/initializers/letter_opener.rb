LetterOpener.configure do |config|
  config.location = Rails.root.join("tmp", "sent_mail")
  config.message_template = :default
end
