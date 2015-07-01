require 'faker'

FactoryGirl.define do
  factory :activity_template do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    activity_type_id { FactoryGirl.create(:activity_type).id }
    rec_min_age nil
    rec_max_age nil
    cost 0
    reward 0
    time_block 30
    restricted { false }
  end

end
