json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :assigned_to_id, :user_id, :contact_id, :ticket_type_id, :date_openned, :date_closed, :status
  json.url ticket_url(ticket, format: :json)
end
