require 'faker'

FactoryGirl.define do
  factory :device_type do
    sequence(:name) { |n| "DeviceType#{n}" }
    description { Faker::Lorem.sentence }
    os { Faker::Lorem.word }
    version { Faker::Lorem.word }
  end

end
