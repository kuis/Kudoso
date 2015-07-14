FactoryGirl.define do
  factory :partner do
    name { Faker::Lorem.sentence(3)}
    description { Faker::Lorem.sentence(5)}
  end

end
