FactoryBot.define do
  factory :api_token do
    name { "CLI Token" }
    user

    after(:build) do |token|
      token.generate_plaintext_token if token.token_digest.blank?
    end
  end
end
