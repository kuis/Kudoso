json.array!(@plugs) do |plug|
  json.extract! plug, :id, :mac_address, :serial, :secure_key, :last_seen, :last_known_ip, :deivce
  json.url plug_url(plug, format: :json)
end
