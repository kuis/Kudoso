json.array!(@devices) do |device|
  json.extract! device, :id, :name, :device_type_id, :family_id, :managed, :management_id, :primary_member_id
  json.url device_url(device, format: :json)
end
