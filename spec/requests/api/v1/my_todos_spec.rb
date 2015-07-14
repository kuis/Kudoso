# spec/requests/api/v1/members_spec.rb

require 'rails_helper'

describe 'Members API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    @device =  FactoryGirl.create(:api_device)
    @todo_templates = FactoryGirl.create_list(:todo_template, 5)
    @todo_templates.each do |todo|
      res = @member.family.assign_template(todo, [ @member.id ])
    end
    @member.reload
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of todos for a family member' do
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos",
          nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["my_todos"].length).to eq(@todo_templates.length)
  end

  it 'creates a todo for a family member'  do
    todo_schedule = @member.todo_schedules.all.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos",
        { my_todo: { todo_schedule_id: todo_schedule.id, due_date: Date.today, complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)

    json = JSON.parse(response.body)
    expect(json["my_todo"]["complete"]).to be_truthy
  end

  it 'returns and error on create for a bad todo_schedule' do
    todo_schedule = @member.todo_schedules.all.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos",
         { my_todo: { todo_schedule_id: (todo_schedule.id + 1000), due_date: Date.today, complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).not_to eq(200)
  end

  it 'updates an existing todo for a family member'  do
    todo_schedule = @member.todo_schedules.all.sample
    my_todo = @member.my_todos.create( todo_schedule_id: todo_schedule.id, due_date: Date.today )
    expect(my_todo.complete).to be_falsey
    patch "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos/#{my_todo.id}",
         { my_todo: { complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["my_todo"]["complete"]).to be_truthy
  end

  it 'allows a parent to verify a todo' do
    todo_schedule = @member.todo_schedules.all.sample
    my_todo = @member.my_todos.create( todo_schedule_id: todo_schedule.id, due_date: Date.today )
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos/#{my_todo.id}/verify", nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
  end

  it 'does not allow a child to verify a todo' do
    post '/api/v1/sessions', { device_token: @device.device_token, family_id: @member.family_id, username: @member.username, password: Digest::MD5.hexdigest('password' + @member.family.secure_key ).to_s }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    token = json["token"]

    todo_schedule = @member.todo_schedules.all.sample
    my_todo = @member.my_todos.create( todo_schedule_id: todo_schedule.id, due_date: Date.today )
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_todos/#{my_todo.id}/verify", nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{token}\""  }
    expect(response.status).to eq(403)
  end


end
