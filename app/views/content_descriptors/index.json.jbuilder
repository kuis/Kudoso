json.array!(@content_descriptors) do |content_descriptor|
  json.extract! content_descriptor, :id, :tag, :short, :description
  json.url content_descriptor_url(content_descriptor, format: :json)
end
