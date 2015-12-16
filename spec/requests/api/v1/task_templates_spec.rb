# spec/requests/api/v1/task_templates_spec.rb

require 'rails_helper'

describe 'Task Templates API', type: :request do
  before(:all) do
    @task_templates = FactoryGirl.create_list(:task_template, 3)
    @user = FactoryGirl.create(:user)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of task templates' do
    get '/api/v1/task_templates', nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_templates"].length).to eq(TaskTemplate.all.count)
  end

  it 'returns a task template' do
    @task_template = @task_templates.sample
    get "/api/v1/task_templates/#{@task_template.id}", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_template"]["name"]).to eq(@task_template.name)
  end

  it 'assigned and un-assigns task template to family member' do
    @task_template = @task_templates.sample
    member = @user.family.members.last
    expect(member.task_schedules.count).to eq(0)
    post "/api/v1/families/#{@user.family.id}/members/#{member.id}/task_templates/#{@task_template.id}/assign", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    member.reload
    expect(member.task_schedules.count).to eq(1)
    delete "/api/v1/families/#{@user.family.id}/members/#{member.id}/task_templates/#{@task_template.id}/unassign", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    member.reload
    expect(member.task_schedules.count).to eq(0)
  end

  it 'returns a list of task templates specific to a member' do
    member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    get "/api/v1/families/#{@user.family.id}/members/#{member.id}/task_templates", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_templates"].length).to eq(0)
    @task_template = @task_templates.sample
    post "/api/v1/families/#{@user.family.id}/members/#{member.id}/task_templates/#{@task_template.id}/assign", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    get "/api/v1/families/#{@user.family.id}/members/#{member.id}/task_templates", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_templates"].length).to eq(1)
  end


end
