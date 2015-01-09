json.array!(@family_activities) do |family_activity|
  json.extract! family_activity, :id, :family_id, :activity_template_id, :name, :description, :rec_min_age, :rec_max_age, :cost, :reward, :time_block, :restricted
  json.url family_activity_url(family_activity, format: :json)
end
