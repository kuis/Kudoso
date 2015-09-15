# spec/requests/api/v1/devices_spec.rb

require 'rails_helper'

describe 'Devices API', type: :request do
  before(:each) do
    @device = FactoryGirl.create(:device)
    @api_device =  FactoryGirl.create(:api_device)
  end

  it 'successfully handles a mobicip deviceDidRegister callback' do
    wifi_mac = SecureRandom.hex(12)
    query_str = { device_token: @api_device.device_token, wifi_mac:wifi_mac, udid: SecureRandom.uuid, product_name: 'yahoo', model_name: @device.device_type.name }
    post "/api/v1/devices/#{@device.uuid}/deviceDidRegister", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Signature' => Digest::MD5.hexdigest(ActiveSupport::JSON.encode(query_str) + @api_device.device_token.reverse) }
    expect(response.status).to eq(200)
    @device.reload
    expect(@device.wifi_mac).to eq(wifi_mac)
  end

  it 'successfully handles a mobicip stats callback' do
    cmd = Faker::Lorem.sentence(3)
    last_seen = 5.minutes.ago
    query_str = { device_token: @api_device.device_token, commandExecuted: cmd, lastReachedAt: last_seen.to_i.to_s }
    patch "/api/v1/devices/#{@device.udid}/status", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Signature' => Digest::MD5.hexdigest(ActiveSupport::JSON.encode(query_str) + @api_device.device_token.reverse) }
    expect(response.status).to eq(200)
    @device.reload
    expect(@device.commands.last.name).to eq(cmd)
    expect(@device.last_contact.to_i).to eq(last_seen.to_i)
  end

  context 'authenticated user' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
      @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
      post '/api/v1/sessions', { device_token: @api_device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      @token = json["token"]
    end
    it 'creates a new device' do
      query_str = { device: { mac_address: 'aa:11:bb:22:ef', name: 'aa:11:bb:22:ef'} }
      post "/api/v1/families/#{@user.family_id}/devices", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""   }
      expect(response.status).to eq(200)
    end

    it 'finds a device with the same mac_address instead of creates' do
      query_str = { device: { mac_address: 'aa:11:bb:22:ef', name: 'aa:11:bb:22:ef'} }
      post "/api/v1/families/#{@user.family_id}/devices", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""   }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      device_id = json["device"]["id"]
      expect(device_id).to_not be_nil
      query_str = { device: { mac_address: 'aa:11:bb:22:ef', name: 'Differnet Name'} }
      post "/api/v1/families/#{@user.family_id}/devices", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""   }
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["device"]["id"]).to eq(device_id)
    end
  end



end