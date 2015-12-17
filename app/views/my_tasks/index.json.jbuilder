json.array!(@my_tasks) do |my_task|
  json.extract! my_task, :id, :task_schedule_id, :member_id, :due_date, :due_time, :complete, :verify, :verified_at, :verified_by
  json.url my_task_url(my_task, format: :json)
end
