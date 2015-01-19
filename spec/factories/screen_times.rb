FactoryGirl.define do
  factory :screen_time do
    member_id { FactoryGirl.create(:member).id }
    device_id { FactoryGirl.create(:device).id }
    dow 1
    maxtime { 60*60 }
  end

end
