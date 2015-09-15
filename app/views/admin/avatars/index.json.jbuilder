json.array!(@avatars) do |avatar|
  json.extract! avatar, :id, :name, :gender, :theme_id
  json.url avatar_url(avatar, format: :json)
end
