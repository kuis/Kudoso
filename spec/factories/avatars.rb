FactoryGirl.define do
  factory :avatar do
    name { Faker::Lorem.words(2) }
    gender { %w( m f ).sample }
    theme_id { FactoryGirl.create(:theme).id}
    image nil
  end

end
