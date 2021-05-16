FactoryBot.define do
  factory :complaint do
    description { Faker::Lorem.paragraph }
    lat { 39.755695}
    long { -104.995986 }
    user 
  end
end
