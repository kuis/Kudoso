# spec/requests/api/v1/users_spec.rb

require 'rails_helper'

describe 'Users API', type: :request do
  before(:all) do
    # @user = FactoryGirl.create(:user)
    # @members = FactoryGirl.create_list(:member, 3, family_id: @user.member.family.id)
    @device =  FactoryGirl.create(:api_device)
    # post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    # expect(response.status).to eq(200)
    # json = JSON.parse(response.body)
    # @token = json["token"]
  end

  it 'can create a new user' do
    post '/api/v1/users', { device_token: @device.device_token, user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John', last_name: 'Depp'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["user"]).to be_present
  end

  it 'reports error on create without last name' do
    post '/api/v1/users', { device_token: @device.device_token, user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(400)
    json = JSON.parse(response.body)
    expect(json["messages"]["error"].length).to be >= 1
  end

  it 'reports an error if duplicate user' do
    post '/api/v1/users', { device_token: @device.device_token, user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John', last_name: 'Depp'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    post '/api/v1/users', { device_token: @device.device_token, user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John', last_name: 'Depp'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(400)
    json = JSON.parse(response.body)
    expect(json["messages"]["error"].length).to be >= 1
  end

  it 'can retrieve user details' do
    post '/api/v1/users', { device_token: @device.device_token, user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John', last_name: 'Depp'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    get "/api/v1/users/#{json["user"]["id"]}", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{json["token"]}\"" }
    expect(response.status).to eq(200)
    json2 = JSON.parse(response.body)
    expect(json2["user"]).to be_present
  end

  it 'can reset user password for a valid user' do
    @user = FactoryGirl.create(:user)
    post '/api/v1/users/reset_password', { device_token: @device.device_token, email: @user.email }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
  end

  it 'cannot reset user password for an invalid user' do
    @user = FactoryGirl.create(:user)
    post '/api/v1/users/reset_password', { device_token: @device.device_token, email: 'jibberish@noemail.co' }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(409)
    json = JSON.parse(response.body)
    expect(json["messages"]["error"].length).to be >= 1
  end

  it 'retruns a proper error when no device token is submited' do
    post '/api/v1/users', { user: { email: "john@example.com", password: 'password', password_confirmation: 'password', first_name: 'John', last_name: 'Depp'} }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(401)
    json = JSON.parse(response.body)
    expect(json["messages"]["error"].length).to be >= 1
  end


end
