FactoryGirl.define do
  factory :router_firmware do
    router_model_id { FactoryGirl.create(:router_model).id }
    version { Faker::Lorem.word }
    checksum { SecureRandom.hex(16) }
    notes { Faker::Lorem.sentence }
  end

end
