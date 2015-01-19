require 'faker'

FactoryGirl.define do
  factory :todo_schedule do
    todo_id { FactoryGirl.create(:todo).id }
    member_id { FactoryGirl.create(:member).id }
    start_date { Date.today }
    end_date nil
    active true
    notes { Faker::Lorem.paragraph }

    after(:create) {|ts| ts.schedule_rrules << FactoryGirl.create(:schedule_rrule, todo_schedule: ts) }
  end

end
