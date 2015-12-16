FactoryGirl.define do
  due_at = Time.now.localtime
  factory :my_task do
    member_id { FactoryGirl.create(:member).id }
    due_date { due_at.to_date }
    due_time { due_at }
    complete false
    verify false
    verified_at nil
    verified_by nil

    after(:build) { |mt| mt.task_schedule_id = FactoryGirl.create(:task_schedule, member_id: mt.member_id).id }

  end

end
