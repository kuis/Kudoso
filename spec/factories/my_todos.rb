FactoryGirl.define do
  factory :my_todo do
    todo_schedule_id 1
member_id 1
due_date "2014-11-21"
due_time "2014-11-21 13:10:40"
complete false
verify false
verified_at "2014-11-21 13:10:40"
verified_by 1
  end

end
