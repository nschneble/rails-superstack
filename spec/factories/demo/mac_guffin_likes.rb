FactoryBot.define do
  factory :mac_guffin_like, class: Demo::MacGuffinLike do
    association :user
    association :mac_guffin
  end
end
