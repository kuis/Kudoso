FactoryGirl.define do
  factory :screen_time do
    member_id { FactoryGirl.create(:member).id }
    dow 1
    max_time { 3*60*60 }
    default_time { 2*60*60 }
  end

end
