require 'faker'

FactoryGirl.define do
  factory :todo do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    required false
    kudos 10
    todo_template_id { FactoryGirl.create(:todo_template).id }
    family_id { FactoryGirl.create(:family).id }
    active true
    schedule { "#{IceCube::Rule.daily.to_yaml}" }
  end

end
