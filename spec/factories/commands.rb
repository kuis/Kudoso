FactoryGirl.define do
  factory :command do
    device_id { FactoryGirl.create(:device).id }
    name { Faker::Lorem.word }
    executed false
    sent nil
    status nil
    result nil
  end

end
