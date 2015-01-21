require 'faker'

FactoryGirl.define do
  factory :todo_template do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    kudos 0
    active true

    after(:build) { |tt| tt.rule = IceCube::Rule.daily.to_yaml }
  end

end
