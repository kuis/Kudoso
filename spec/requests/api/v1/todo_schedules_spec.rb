# spec/requests/api/v1/todo_templates_spec.rb

require 'rails_helper'

describe 'Todo Schedules API', type: :request do
  before(:all) do

    @user = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:member, family_id: @user.family_id)
    @todos = FactoryGirl.create_list(:todo, 3, family_id: @user.family_id)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'should allow creating a new todo schedule with multiple rules' do
    todo = @todos.sample
    prev_schedules = @member.todo_schedules.count
    rules = []
    rules << IceCube::Rule.weekly.day(:monday).to_hash
    rules << IceCube::Rule.weekly(2).day(:wednesday).to_hash
    post "/api/v1/families/#{@user.family.id}/todos/#{todo.id}/todo_schedules",
          { member_id: @member.id, todo_id: todo.id, rules: rules }.to_json,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_schedule"]["id"].present?).to be_truthy
    expect(json["todo_schedule"]["start_date"]).to_not be_nil
    expect(json["todo_schedule"]["rrules"].count).to eq(2)
    @member.reload
    expect(@member.todo_schedules.count).to eq(prev_schedules + 1)
  end

  it 'should allow updating a new todo schedule' do
    todo_schedule = FactoryGirl.create(:todo_schedule, member_id: @member.id)
    patch "/api/v1/families/#{@user.family.id}/todos/#{todo_schedule.todo_id}/todo_schedules/#{todo_schedule.id}",
         { end_date: 1.month.from_now.to_s }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["todo_schedule"]["id"].present?).to be_truthy
    expect(json["todo_schedule"]["end_date"]).to_not be_nil
  end

  it 'should allow deleting a todo schedule' do
    todo_schedule = FactoryGirl.create(:todo_schedule, member_id: @member.id)
    delete "/api/v1/families/#{@user.family.id}/todos/#{todo_schedule.todo_id}/todo_schedules/#{todo_schedule.id}",
          nil,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
  end

  it 'should return all todos schedules for a todo' do
    todo = @todos.sample
    todo_schedules = FactoryGirl.create_list(:todo_schedule, 4, todo_id: todo.id)
    get "/api/v1/families/#{@user.family.id}/todos/#{todo.id}/todo_schedules",
           nil,
           { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    todo.reload
    expect(json["todo_schedules"].count).to eq(todo.todo_schedules.count)
  end



end
