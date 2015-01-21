require 'faker'

FactoryGirl.define do
  factory :device_type do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    os { Faker::Lorem.word }
    version { Faker::Lorem.word }
  end

end
