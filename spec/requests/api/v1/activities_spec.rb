# spec/requests/api/v1/activities_spec.rb

require 'rails_helper'

describe 'Activities API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    @api_device =  FactoryGirl.create(:api_device)
    @task_templates = FactoryGirl.create_list(:task_template, 5)
    @task_templates.each do |task|
      res = @member.family.assign_template(task, [ @member.id ])
    end
    @devices = FactoryGirl.create_list(:device, 8, family_id: @member.family_id)
    @activity_template = FactoryGirl.create(:activity_template)
    @member.reload
    @member.password = 'password'
    @member.password_confirmation = 'password'
    @member.save
    post '/api/v1/sessions',
         { device_token: @api_device.device_token, family_id: @member.family_id, username: @member.username, password: Digest::MD5.hexdigest('password' + @member.family.secure_key ).to_s }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'creates a new activity' do
    device =  @devices.sample
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         { devices: [ device.id ], activity_template_id: @activity_template.id}.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    act= Activity.find(json["activity"]["id"])
    expect(act.devices).to match_array([ device ])
  end

  it 'starts an activity' do
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         { devices: [ @devices.sample.id ], activity_template_id: @activity_template.id}.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    expect(json["activity"]["start_time"]).to be_nil
    put "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities/#{json["activity"]["id"]}",
         { start: true}.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    expect(json["activity"]["start_time"]).to_not be_nil
  end

  it 'starts and stops an activity' do
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         { ddevices: [ @devices.sample.id ], activity_template_id: @activity_template.id}.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    expect(json["activity"]["start_time"]).to be_nil
    put "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities/#{json["activity"]["id"]}",
        { start: true}.to_json,
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    expect(json["activity"]["start_time"]).to_not be_nil
    expect(json["activity"]["end_time"]).to be_nil
    sleep 2
    put "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities/#{json["activity"]["id"]}",
        { stop: true}.to_json,
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
    expect(json["activity"]["start_time"]).to_not be_nil
    expect(json["activity"]["end_time"]).to_not be_nil

  end

  it 'gets a list of activities for the day' do
    activities = FactoryGirl.create_list(:activity, 3, member_id: @member.id, activity_template_id: @activity_template.id )
    yest_act = FactoryGirl.create(:activity, member_id: @member.id, activity_template_id: @activity_template.id )
    yest_act.update_attribute(:created_at, 1.day.ago)
    @member.reload
    expect(@member.activities.count).to eq(4)
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         nil,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activities"].length).to eq(3)
  end

  it 'gets a list of activities for the day for a specific activity_template' do
    activities = FactoryGirl.create_list(:activity, 3, member_id: @member.id, activity_template_id: @activity_template.id )
    activities.each do |act|
      act.devices << @devices.sample
    end
    @activity_template2 = FactoryGirl.create(:activity_template)
    activities2 = FactoryGirl.create_list(:activity, 3, member_id: @member.id, activity_template_id: @activity_template2.id )
    activities2.each do |act|
      act.devices << @devices.sample
    end
    yest_act = FactoryGirl.create(:activity, member_id: @member.id, activity_template_id: @activity_template.id )
    yest_act.update_attribute(:created_at, 1.day.ago)
    @member.reload
    expect(@member.activities.count).to eq(7)
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
        { activity_template_id: @activity_template.id },
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activities"].length).to eq(3)
  end

  it 'includes devices with acticity' do
    act = FactoryGirl.create(:activity, member_id: @member.id, activity_template_id: @activity_template.id )
    @devices.each{ |device| act.devices << device}
    @member.reload
    expect(act.devices.count).to eq(@devices.count)
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
        nil,
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activities"][0]["devices"].length).to eq(@devices.count)
  end




end
