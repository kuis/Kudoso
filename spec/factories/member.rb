require 'faker'

FactoryGirl.define do
  factory :member do
    username { Faker::Internet.user_name }
    password { Faker::Internet.password }
    birth_date { Faker::Time.between(15.years.ago, 2.years.ago).to_date }
    parent false
    family_id { FactoryGirl.create(:family).id }
  end
end
