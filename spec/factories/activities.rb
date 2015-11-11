FactoryGirl.define do
  factory :activity do
    member_id { FactoryGirl.create(:member).id }
    start_time { 1.hour.ago }
    end_time { 10.minutes.ago }
    content_id nil
    allowed_time 30
    activity_template_id { FactoryGirl.create( :activity_template ).id }
    cost 0
    reward 0

    after(:build) {  |act|
       act.created_by_id = act.member_id
    }

  end

end
