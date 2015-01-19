require 'faker'

FactoryGirl.define do
  factory :family do
    name { Faker::Lorem.word }
    primary_contact_id nil
  end
end
