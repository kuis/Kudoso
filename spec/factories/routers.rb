FactoryGirl.define do
  factory :router do
    router_model_id { FactoryGirl.create(:router_model)}
    router_firmware_id { FactoryGirl.create(:router_firmware) }
    family_id { FactoryGirl.create(:family)}
    mac_address {Faker::Internet.mac_address}
  end

end
