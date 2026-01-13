FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    email_confirmed_at { nil }
    last_login_at { nil }
    last_login_ip { nil }
    login_count { 0 }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
