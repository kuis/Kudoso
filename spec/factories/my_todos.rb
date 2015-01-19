FactoryGirl.define do
  due_at = Time.now
  factory :my_todo do
    todo_schedule_id { FactoryGirl.create(:todo_schedule).id}
    member_id { FactoryGirl.create(:member).id }
    due_date { due_at.to_date }
    due_time { due_at }
    complete false
    verify false
    verified_at nil
    verified_by nil
  end

end
