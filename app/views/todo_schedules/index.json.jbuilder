json.array!(@todo_schedules) do |todo_schedule|
  json.extract! todo_schedule, :id, :todo_id, :member_id, :start_date, :end_date, :active, :schedule, :notes
  json.url todo_schedule_url(todo_schedule, format: :json)
end
