# spec/requests/api/v1/todo_templates_spec.rb

require 'rails_helper'

describe 'Todo Schedules API', type: :request do
  before(:all) do

    @user = FactoryGirl.create(:user)
    @member = FactoryGirl.create(:member, family_id: @user.family_id)
    @todos = FactoryGirl.create_list(:my_todo, 3, member_id: @member.id)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'should allow recurring rules to be updated' do
    todo_schedule = @todos.sample.todo_schedule
    todo_schedule.schedule_rrules.each{|rr| rr.destroy}
    todo_schedule.reload
    expect(todo_schedule.schedule_rrules.length).to eq(0)
    rule = IceCube::Rule.weekly.day(:monday)
    patch "/api/v1/families/#{@user.family.id}/todo_schedules/#{todo_schedule.id}",
          { rule: rule.to_hash}.to_json,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
  end



end
