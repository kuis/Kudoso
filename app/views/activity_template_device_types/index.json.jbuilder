json.array!(@activity_template_device_types) do |activity_template_device_type|
  json.extract! activity_template_device_type, :id, :activity_template_id, :device_type_id, :type, :launch_url, :app_name, :app_id, :app_store_url
  json.url activity_template_device_type_url(activity_template_device_type, format: :json)
end
