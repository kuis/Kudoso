json.array!(@activities) do |activity|
  json.extract! activity, :id, :member_id, :created_by, :family_activity_id, :start_time, :end_time, :device_id, :content_id, :allowed_time, :activity_type_id, :cost, :reward
  json.url activity_url(activity, format: :json)
end
