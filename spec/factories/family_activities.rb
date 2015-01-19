require 'faker'

FactoryGirl.define do
  factory :family_activity do
    family_id 1
    activity_template_id 1
    name "MyString"
    description "MyString"
    cost 1
    reward 1
    time_block 1
    restricted false
  end

end
