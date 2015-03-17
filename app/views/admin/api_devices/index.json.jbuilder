json.array!(@api_devices) do |api_device|
  json.extract! api_device, :id, :device_token, :name, :expires_at
  json.url api_device_url(api_device, format: :json)
end
