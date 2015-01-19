require 'faker'

FactoryGirl.define do
  factory :content_rating do
    org { Faker::Lorem.word }
    tag { Faker::Lorem.word }
    short { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end

end
