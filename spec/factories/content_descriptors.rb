require 'faker'

FactoryGirl.define do
  factory :content_descriptor do
    tag { Faker::Lorem.word }
    short { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end

end
