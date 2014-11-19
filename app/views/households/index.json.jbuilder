json.array!(@households) do |household|
  json.extract! household, :id, :name, :primary_contact_id
  json.url household_url(household, format: :json)
end
