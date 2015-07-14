json.array!(@activities) do |activity|
  json.extract! activity, :id, :member_id, :created_by, :activity_template_id, :start_time, :end_time, :device_id, :content_id, :allowed_time, :cost, :reward
  json.url activity_url(activity, format: :json)
end
