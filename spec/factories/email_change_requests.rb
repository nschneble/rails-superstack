FactoryBot.define do
  factory :email_change_request do
    new_email { Faker::Internet.unique.email }
    token { Faker::Internet.uuid }
    expires_at { 10.minutes.from_now }

    user

    trait :expired do
      expires_at { 1.minute.ago }

      to_create { |instance| instance.save!(validate: false) }
    end
  end
end
