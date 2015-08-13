json.array!(@router_firmwares) do |router_firmware|
  json.extract! router_firmware, :id, :router_model_id, :version, :url, :notes
  json.url router_firmware_url(router_firmware, format: :json)
end
