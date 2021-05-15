FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      password { '1amr00t' } 
      name { Faker::Name.name }
    end
  end
  