json.array!(@content_ratings) do |content_rating|
  json.extract! content_rating, :id, :type, :tag, :short, :description
  json.url content_rating_url(content_rating, format: :json)
end
