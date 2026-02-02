FactoryBot.define do
  factory :mac_guffin, class: Demo::MacGuffin do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    visibility { :open }

    association :user

    trait :user do
      visibility { :user }
    end

    trait :admin do
      visibility { :admin }
      association :user, :admin
    end

    trait :cat do
      name { Faker::Creature::Cat.name }
      description { Faker::Creature::Cat.breed }
    end

    trait :color do
      name { Faker::Color.color_name }
      description { Faker::Color.hex_color }
    end

    trait :food do
      name { Faker::Food.dish }
      description { Faker::Food.description }
    end
  end
end
