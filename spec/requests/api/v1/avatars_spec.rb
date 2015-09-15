# spec/requests/api/v1/avatars_spec.rb

require 'rails_helper'

describe 'Avatars API', type: :request do
  before(:all) do
    @avatars = FactoryGirl.create_list(:avatar, 5)
    @api_device =  FactoryGirl.create(:api_device)

    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    post '/api/v1/sessions', { device_token: @api_device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns a list of avatars' do
    get '/api/v1/avatars', nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""   }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    avatars = json["avatars"]
    expect(avatars.is_a?(Array)).to be_truthy
    expect(avatars.count).to eq(Avatar.all.count)
  end


end