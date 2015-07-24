# spec/requests/api/v1/devices_spec.rb

require 'rails_helper'

describe 'Devices API', type: :request do
  before(:each) do
    @device = FactoryGirl.create(:device)
    @api_device =  FactoryGirl.create(:api_device)
  end

  it 'successfully handles a mobicip deviceDidRegister callback' do
    wifi_mac = SecureRandom.hex(12)
    query_str = { device_token: @api_device.device_token, wifi_mac:wifi_mac, product_name: 'yahoo', model_name: @device.device_type.name }
    post "/api/v1/devices/#{@device.uuid}/deviceDidRegister", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Signature' => Digest::MD5.hexdigest(ActiveSupport::JSON.encode(query_str) + @api_device.device_token.reverse) }
    expect(response.status).to eq(200)
    @device.reload
    expect(@device.wifi_mac).to eq(wifi_mac)
  end

  it 'successfully handles a mobicip stats callback' do
    cmd = Faker::Lorem.sentence(3)
    query_str = { device_token: @api_device.device_token, udid: @device.udid, commandExecuted: cmd }
    patch "/api/v1/devices/#{@device.uuid}/status", query_str.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Signature' => Digest::MD5.hexdigest(ActiveSupport::JSON.encode(query_str) + @api_device.device_token.reverse) }
    expect(response.status).to eq(200)
    @device.reload
    expect(@device.commands.last.name).to eq(cmd)
  end


end