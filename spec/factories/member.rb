require 'faker'

FactoryGirl.define do
  factory :member do
    first_name { Faker::Name.first_name}
    last_name { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password }
    birth_date { Faker::Time.between(50.years.ago, 5.years.ago).to_date }
    parent false
    family_id { FactoryGirl.create(:family).id }
  end
end
