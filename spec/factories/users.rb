FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    email_confirmed_at { nil }
    last_login_at { nil }
    last_login_ip { nil }
    login_count { 0 }
    role { :user }

    trait :confirmed do
      email_confirmed_at { 1.day.ago }
      last_login_at { 1.day.ago }
      last_login_ip { Faker::Internet.public_ip_v4_address }
      login_count { 1 }
    end

    trait :admin do
      role { :admin }
    end
  end
end
