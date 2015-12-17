json.array!(@task_schedules) do |task_schedule|
  json.extract! task_schedule, :id, :task_id, :member_id, :start_date, :end_date, :active, :schedule, :notes
  json.url task_schedule_url(task_schedule, format: :json)
end
