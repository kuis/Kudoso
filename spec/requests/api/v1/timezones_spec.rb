# spec/requests/api/v1/sessions_spec.rb

require 'rails_helper'

describe 'Timezones API', type: :request do

  it 'successfully returns the US time zones' do
    get '/api/v1/timezones', nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json).to match_array(ActiveSupport::TimeZone.us_zones.collect{|tz| tz.name })
  end


end