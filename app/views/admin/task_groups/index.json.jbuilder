json.array!(@task_groups) do |task_group|
  json.extract! task_group, :id, :name, :rec_min_age, :rec_max_age, :active
  json.url task_group_url(task_group, format: :json)
end
