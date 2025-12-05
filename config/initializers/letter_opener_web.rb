LetterOpenerWeb.configure do |config|
  config.letters_location = Rails.root.join("tmp", "sent_mail")
end
