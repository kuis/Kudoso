json.array!(@activities) do |activity|
  json.extract! activity, :id, :activity_template_id, :name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted
  json.url activity_url(activity, format: :json)
end
