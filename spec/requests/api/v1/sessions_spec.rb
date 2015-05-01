# spec/requests/api/v1/sessions_spec.rb

require 'rails_helper'

describe 'Sessions API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @device =  FactoryGirl.create(:api_device)
  end

  it 'successfully creates a new session as a user' do
    post 'http://api.localhost.dev/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["user"]).to_not be_nil
    expect(json["messages"]).to_not be_nil
    expect(json["messages"]["error"].length).to eq(0)
  end

  it 'returns an error when password is wrong' do
    post 'http://api.localhost.dev/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'wrong  password'}.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    json = JSON.parse(response.body)
    expect(response.status).to eq(401)
    expect(json["messages"]).to_not be_nil
    expect(json["messages"]["error"].length).to be > 0
  end
end