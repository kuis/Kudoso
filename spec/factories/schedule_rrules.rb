FactoryGirl.define do
  factory :schedule_rrule do
    task_schedule_id { FactoryGirl.create(:task_schedule).id }
    rrule {  "#{IceCube::Rule.daily.to_yaml}" }
  end

end
