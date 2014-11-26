json.array!(@my_todos) do |my_todo|
  json.extract! my_todo, :id, :todo_schedule_id, :member_id, :due_date, :due_time, :complete, :verify, :verified_at, :verified_by
  json.url my_todo_url(my_todo, format: :json)
end
