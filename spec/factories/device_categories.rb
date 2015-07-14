FactoryGirl.define do
  factory :device_category do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end

end
