require 'faker'

FactoryGirl.define do
  factory :member do
    username { Faker::Internet.user_name }
    birth_date { Faker::Time.between(15.years.ago, 2.years.ago).to_date }
    parent false
    family_id { FactoryGirl.create(:family).id }
    theme_id { FactoryGirl.create(:theme).id }

    after(:build) { |u| u.password_confirmation = u.password = 'password'; u.save }
  end
end
