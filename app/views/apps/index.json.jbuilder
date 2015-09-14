json.array!(@apps) do |app|
  json.extract! app, :id, :name, :bundle_identifier, :publisher, :url
  json.url app_url(app, format: :json)
end
