FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    email_confirmed_at { nil }
    last_login_at { nil }
    last_login_ip { nil }
    login_count { 0 }
  end
end
