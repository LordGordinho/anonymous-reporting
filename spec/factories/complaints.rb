FactoryBot.define do
  factory :complaint do
    description { Faker::Lorem.paragraph }
    lat { 1.5 }
    long { 1.5 }
    user 
  end
end
