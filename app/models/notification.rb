class Notification < Data.define(:type, :message)
  MAX_MESSAGE_LENGTH = 140
end
