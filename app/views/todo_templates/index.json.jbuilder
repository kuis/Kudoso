json.array!(@todo_templates) do |todo_template|
  json.extract! todo_template, :id, :name, :description, :schedule, :active
  json.url todo_template_url(todo_template, format: :json)
end
