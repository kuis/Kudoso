json.array!(@todo_groups) do |todo_group|
  json.extract! todo_group, :id, :name, :rec_min_age, :rec_max_age, :active
  json.url todo_group_url(todo_group, format: :json)
end
