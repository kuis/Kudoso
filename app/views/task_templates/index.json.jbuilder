json.array!(@task_templates) do |task_template|
  json.extract! task_template, :id, :name, :description, :schedule, :active
  json.url task_template_url(task_template, format: :json)
end
