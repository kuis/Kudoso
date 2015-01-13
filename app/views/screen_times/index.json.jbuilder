json.array!(@screen_times) do |screen_time|
  json.extract! screen_time, :id, :member_id, :device_id, :dow, :maxtime
  json.url screen_time_url(screen_time, format: :json)
end
