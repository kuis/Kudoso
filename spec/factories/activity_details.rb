FactoryGirl.define do
  factory :activity_detail do
    activity_id { FactoryGirl.create(:activity).id }
    metadata "MyText"
  end

end
