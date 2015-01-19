#   parent = User.create({email: 'parent@kudoso.com', first_name: 'Parent', last_name: 'Test', password: 'password', password_confirmation: 'password', confirmed_at: Time.now})

require 'faker'

FactoryGirl.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    member { FactoryGirl.create(:member) }

    after(:build) { |u| u.password_confirmation = u.password = 'password'; u.confirmed_at = Time.now }

  end
end

