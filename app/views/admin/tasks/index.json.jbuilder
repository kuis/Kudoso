json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description, :required, :kudos, :task_template_id, :family_id, :active, :schedule
  json.url task_url(task, format: :json)
end
