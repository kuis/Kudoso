json.array!(@themes) do |theme|
  json.extract! theme, :id, :name, :primary_color, :secondary_color, :primary_bg_color, :secondard_bg_color
  json.url theme_url(theme, format: :json)
end
