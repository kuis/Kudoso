json.array!(@todos) do |todo|
  json.extract! todo, :id, :name, :description, :required, :kudos, :todo_template_id, :family_id, :active, :schedule
  json.url todo_url(todo, format: :json)
end
