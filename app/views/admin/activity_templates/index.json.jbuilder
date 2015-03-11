json.array!(@activity_templates) do |activity_template|
  json.extract! activity_template, :id, :name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted
  json.url activity_template_url(activity_template, format: :json)
end
