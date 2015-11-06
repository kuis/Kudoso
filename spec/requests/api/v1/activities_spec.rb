# spec/requests/api/v1/activities_spec.rb

require 'rails_helper'

describe 'Activities API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    @api_device =  FactoryGirl.create(:api_device)
    @todo_templates = FactoryGirl.create_list(:todo_template, 5)
    @todo_templates.each do |todo|
      res = @member.family.assign_template(todo, [ @member.id ])
    end
    @devices = FactoryGirl.create_list(:device, 3, family_id: @member.family_id)
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
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         { device_id: @devices.sample.id, activity_template_id: @activity_template.id}.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["activity"].present?).to be_truthy
  end

  it 'starts an activity' do
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/activities",
         { device_id: @devices.sample.id, activity_template_id: @activity_template.id}.to_json,
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
         { device_id: @devices.sample.id, activity_template_id: @activity_template.id}.to_json,
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




end
