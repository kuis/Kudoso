# spec/requests/api/v1/task_templates_spec.rb

require 'rails_helper'

describe 'Task Schedules API', type: :request do
  before(:all) do

    @user = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:member, family_id: @user.family_id)
    @tasks = FactoryGirl.create_list(:task, 3, family_id: @user.family_id)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'should allow creating a new task schedule with multiple rules' do
    task = @tasks.sample
    prev_schedules = @member.task_schedules.count
    rules = []
    rules << IceCube::Rule.weekly.day(:monday).to_hash
    rules << IceCube::Rule.weekly(2).day(:wednesday).to_hash
    post "/api/v1/families/#{@user.family.id}/tasks/#{task.id}/task_schedules",
          { member_id: @member.id, task_id: task.id, rules: rules }.to_json,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_schedule"]["id"].present?).to be_truthy
    expect(json["task_schedule"]["start_date"]).to_not be_nil
    expect(json["task_schedule"]["rrules"].count).to eq(2)
    @member.reload
    expect(@member.task_schedules.count).to eq(prev_schedules + 1)
  end

  it 'should allow updating a new task schedule' do
    task_schedule = FactoryGirl.create(:task_schedule, member_id: @member.id)
    patch "/api/v1/families/#{@user.family.id}/tasks/#{task_schedule.task_id}/task_schedules/#{task_schedule.id}",
         { end_date: 1.month.from_now.to_s }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["task_schedule"]["id"].present?).to be_truthy
    expect(json["task_schedule"]["end_date"]).to_not be_nil
  end

  it 'should allow deleting a task schedule' do
    task_schedule = FactoryGirl.create(:task_schedule, member_id: @member.id)
    delete "/api/v1/families/#{@user.family.id}/tasks/#{task_schedule.task_id}/task_schedules/#{task_schedule.id}",
          nil,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
  end

  it 'should return all tasks schedules for a task' do
    task = @tasks.sample
    task_schedules = FactoryGirl.create_list(:task_schedule, 4, task_id: task.id)
    get "/api/v1/families/#{@user.family.id}/tasks/#{task.id}/task_schedules",
           nil,
           { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    task.reload
    expect(json["task_schedules"].count).to eq(task.task_schedules.count)
  end



end
