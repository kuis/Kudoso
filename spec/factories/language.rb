require 'faker'

FactoryGirl.define do
  factory :language do
    name { Faker::Lorem.word }
  end
end
