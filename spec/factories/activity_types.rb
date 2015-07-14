require 'faker'

FactoryGirl.define do
  factory :activity_type do
    name { Faker::Lorem.sentence }
    partner_id { FactoryGirl.create(:partner).id }
  end

end
