# spec/requests/api/v1/members_spec.rb

require 'rails_helper'

describe 'Members API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    @device =  FactoryGirl.create(:api_device)
    @task_templates = FactoryGirl.create_list(:task_template, 5)
    @task_templates.each do |task|
      res = @member.family.assign_template(task, [ @member.id ])
    end
    @member.reload
    @member.password = 'password'
    @member.password_confirmation = 'password'
    @member.save
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of tasks for a family member' do
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks",
          nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["my_tasks"].length).to eq(@task_templates.length)
  end

  it 'creates a task for a family member'  do
    task_schedule = @member.task_schedules.all.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks",
        { my_task: { task_schedule_id: task_schedule.id, due_date: Date.today, complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)

    json = JSON.parse(response.body)
    expect(json["my_task"]["complete"]).to be_truthy
  end

  it 'returns and error on create for a bad task_schedule' do
    task_schedule = @member.task_schedules.all.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks",
         { my_task: { task_schedule_id: (task_schedule.id + 1000), due_date: Date.today, complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).not_to eq(200)
  end

  it 'updates an existing task for a family member'  do
    task_schedule = @member.task_schedules.all.sample
    my_task = @member.my_tasks.create( task_schedule_id: task_schedule.id, due_date: Date.today )
    expect(my_task.complete).to be_falsey
    patch "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks/#{my_task.id}",
         { my_task: { complete: true } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["my_task"]["complete"]).to be_truthy
  end

  it 'allows a parent to verify a task' do
    task_schedule = @member.task_schedules.all.sample
    my_task = @member.my_tasks.create( task_schedule_id: task_schedule.id, due_date: Date.today )
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks/#{my_task.id}/verify", nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
  end

  it 'does not allow a child to verify a task' do
    post '/api/v1/sessions', { device_token: @device.device_token, family_id: @member.family_id, username: @member.username, password: Digest::MD5.hexdigest('password' + @member.family.secure_key ).to_s }.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    token = json["token"]

    task_schedule = @member.task_schedules.all.sample
    my_task = @member.my_tasks.create( task_schedule_id: task_schedule.id, due_date: Date.today )
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/my_tasks/#{my_task.id}/verify", nil, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{token}\""  }
    expect(response.status).to eq(403)
  end


end
