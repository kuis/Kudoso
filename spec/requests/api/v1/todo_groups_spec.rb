# spec/requests/api/v1/todo_groups_spec.rb

require 'rails_helper'

describe 'Todo Groups API', type: :request do
  before(:all) do
    @todo_groups = FactoryGirl.create_list(:todo_group, 3)
    @user = FactoryGirl.create(:user)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of todo groups' do
    get '/api/v1/todo_groups', nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_groups"].length).to eq(TodoGroup.active.count)
  end

  it 'returns a todo groups with todo templates' do
    @todo_group = @todo_groups.sample
    get "/api/v1/todo_groups/#{@todo_group.id}", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_group"]["todo_templates"].length).to eq(@todo_group.todo_templates.count)
  end

  it 'assigns todo group to family member' do
    @todo_group = @todo_groups.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@user.family.members.last.id}/todo_groups/#{@todo_group.id}/assign", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
  end


end
