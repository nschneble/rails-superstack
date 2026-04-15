Rails.application.config.to_prepare do
  User.class_eval do
    has_many :mac_guffins,      class_name: "Demo::MacGuffin",     dependent: :destroy
    has_many :mac_guffin_likes, class_name: "Demo::MacGuffinLike", dependent: :destroy
  end
end
