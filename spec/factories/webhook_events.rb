FactoryBot.define do
  factory :webhook_event do
    stripe_event_id { "evt_#{SecureRandom.hex(8)}" }
    event_type { "customer.subscription.updated" }
    status { :pending }
    payload { { "data" => { "object" => {} } } }
  end
end
