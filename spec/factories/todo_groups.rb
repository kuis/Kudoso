require 'faker'

FactoryGirl.define do
  factory :todo_group do
    name { Faker::Lorem.sentence(4)}
    rec_min_age 1
    rec_max_age 19
    active true

    after(:create) { |tg| 3.times { tg.todo_templates << FactoryGirl.create(:todo_template) } }
  end

end
