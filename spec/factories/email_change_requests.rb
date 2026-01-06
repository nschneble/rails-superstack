FactoryBot.define do
  factory :email_change_request do
    new_email { Faker::Internet.unique.email }
    token { Faker::Internet.uuid }
    expires_at { 10.minutes.from_now }

    association :user
  end
end
