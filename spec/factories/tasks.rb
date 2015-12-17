require 'faker'

FactoryGirl.define do
  factory :task do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    required false
    kudos 10
    task_template_id { FactoryGirl.create(:task_template).id }
    family_id { FactoryGirl.create(:family).id }
    active true
    schedule { "#{IceCube::Rule.daily.to_yaml}" }
  end

end
