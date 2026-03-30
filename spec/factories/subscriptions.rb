FactoryBot.define do
  factory :subscription do
    user
    stripe_customer_id { "cus_#{SecureRandom.hex(8)}" }
    stripe_subscription_id { "sub_#{SecureRandom.hex(8)}" }
    plan { "free" }
    status { :active }
    current_period_end_at { 1.year.from_now }

    trait :pro_monthly do
      plan { "pro_monthly" }
      current_period_end_at { 30.days.from_now }
    end

    trait :pro_yearly do
      plan { "pro_yearly" }
    end

    trait :trialing do
      status { :trialing }
      current_period_end_at { 7.days.from_now }
      trial_ends_at { 7.days.from_now }
    end

    trait :canceled do
      status { :canceled }
    end

    trait :past_due do
      status { :past_due }
    end
  end
end
