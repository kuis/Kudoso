json.array!(@activity_details) do |activity_detail|
  json.extract! activity_detail, :id, :activity_id, :metadata
  json.url activity_detail_url(activity_detail, format: :json)
end
