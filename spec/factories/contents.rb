require 'faker'

FactoryGirl.define do
  factory :content do
    content_type_id { FactoryGirl.create(:content_type).id}
    title { Faker::Lorem.sentence }
    year "1996"
    content_rating_id { FactoryGirl.create(:content_rating).id}
    release_date { "#{10.years.ago.to_date}"}
    language "en"
    description { Faker::Lorem.paragraph }
    length "60min"
    metadata { Faker::Lorem.paragraph }
    references { Faker::Lorem.paragraph }
  end

end
