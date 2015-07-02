# spec/requests/api/v1/todo_templates_spec.rb

require 'rails_helper'

describe 'Todo Templates API', type: :request do
  before(:all) do
    @todo_templates = FactoryGirl.create_list(:todo_template, 3)
    @user = FactoryGirl.create(:user)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of todo templates' do
    get '/api/v1/todo_templates', nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_templates"].length).to eq(TodoTemplate.all.count)
  end

  it 'returns a todo template' do
    @todo_template = @todo_templates.sample
    get "/api/v1/todo_templates/#{@todo_template.id}", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_template"]["name"]).to eq(@todo_template.name)
  end

  it 'assigns todo template to family member' do
    @todo_template = @todo_templates.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@user.family.members.last.id}/todo_templates/#{@todo_template.id}/assign", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
  end


end
