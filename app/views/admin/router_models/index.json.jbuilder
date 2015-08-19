json.array!(@router_models) do |router_model|
  json.extract! router_model, :id, :name, :num
  json.url router_model_url(router_model, format: :json)
end
