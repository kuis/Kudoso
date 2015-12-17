require 'faker'

FactoryGirl.define do
  factory :task_schedule do
    task_id { FactoryGirl.create(:task).id }
    member_id { FactoryGirl.create(:member).id }
    start_date { Date.today }
    end_date { nil }
    active true
    notes { Faker::Lorem.sentence }

    after(:create) {|ts| ts.schedule_rrules << FactoryGirl.create(:schedule_rrule, task_schedule: ts) }
  end

end
