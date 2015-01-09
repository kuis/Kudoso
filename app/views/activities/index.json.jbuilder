json.array!(@activities) do |activity|
  json.extract! activity, :id, :member_id, :family_activity_id, :date, :duration, :device_id, :notes
  json.url activity_url(activity, format: :json)
end
