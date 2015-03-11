json.array!(@contacts) do |contact|
  json.extract! contact, :id, :first_name, :last_name, :company, :primary_email_id, :address1, :address2, :city, :state, :zip, :address_type_id, :phone, :phone_type_id, :last_contact, :do_not_call, :do_not_email, :contact_type_id
  json.url contact_url(contact, format: :json)
end
