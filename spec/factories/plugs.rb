FactoryGirl.define do
  factory :plug do
    mac_address "12:34:56:ab:cd:ef"
    serial { SecureRandom.hex(16) }
    last_seen "2015-08-25 11:00:33"
    last_known_ip "192.168.1.1"
    device { FactoryGirl.create(:device) }
  end

end
