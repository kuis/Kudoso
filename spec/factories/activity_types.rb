require 'faker'

FactoryGirl.define do
  factory :activity_type do
    name { Faker::Lorem.sentence }
  end

end
