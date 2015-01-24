require 'faker'

FactoryGirl.define do
  factory :family_activity do
    family_id { FactoryGirl.create(:family).id}
    activity_template_id {FactoryGirl.create(:activity_template).id}
    name "MyString"
    description "MyString"
    cost 1
    reward 1
    time_block 1
    restricted false
  end

end
