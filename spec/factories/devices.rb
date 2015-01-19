require 'faker'

FactoryGirl.define do
  factory :device do
    name { Faker::Lorem.word }
    device_type_id { FactoryGirl.create(:device_type).id }
    family_id { FactoryGirl.create(:family).id }
    managed false
    management_id nil
    primary_member_id nil
  end
end
