require 'faker'

FactoryGirl.define do
  factory :device do
    name { SecureRandom.hex(24) }
    device_type_id { FactoryGirl.create(:device_type).id }
    family_id { FactoryGirl.create(:family).id }
    managed false
    management_id nil
    primary_member_id nil
    udid { SecureRandom.hex(24) }
    wifi_mac { SecureRandom.hex(12) }
    last_contact { 2.days.ago }
    os_version "7.2a"
    build_version {SecureRandom.base64(24)}
    product_name { Faker::Lorem.word  }
  end
end
