# spec/requests/api/v1/activity_templates_spec.rb

require 'rails_helper'

describe 'Activity Templates API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @members = FactoryGirl.create_list(:member, 3, family_id: @user.member.family.id)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
    @ats = FactoryGirl.create_list(:activity_template, 5)
  end

  it 'returns the activity_templates for the family' do
    get "/api/v1/families/#{@user.family.id}/activity_templates", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    json = JSON.parse(response.body)
    expect(json["activity_templates"].length).to eq(@ats.count)
  end

  it 'returns the activity_templates for the family with preferences' do

    @user.family.family_activity_preferences.create(activity_template_id: @ats.first.id, reward: 1234, preferred: true)
    get "/api/v1/families/#{@user.family.id}/activity_templates", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    json = JSON.parse(response.body)
    expect(json["activity_templates"].length).to eq(@ats.count)
    expect(json["activity_templates"].first["reward"]).to eq(1234)

  end


end