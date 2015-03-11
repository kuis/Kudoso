json.array!(@notes) do |note|
  json.extract! note, :id, :ticket_id, :note_type_id, :title, :body
  json.url note_url(note, format: :json)
end
