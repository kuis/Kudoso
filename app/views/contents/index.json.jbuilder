json.array!(@contents) do |content|
  json.extract! content, :id, :content_type_id, :title, :year, :content_rating_id, :release_date, :language_id, :description, :length, :metadata, :references
  json.url content_url(content, format: :json)
end
