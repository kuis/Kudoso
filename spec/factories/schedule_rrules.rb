FactoryGirl.define do
  factory :schedule_rrule do
    todo_schedule_id { FactoryGirl.create(:todo_schedule).id }
    rrule {  "#{IceCube::Rule.daily.to_yaml}" }
  end

end
