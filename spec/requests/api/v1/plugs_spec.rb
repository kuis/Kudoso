# spec/requests/api/v1/devices_spec.rb

require 'rails_helper'

describe 'Plugs API', type: :request do
  before(:each) do
    @plug = FactoryGirl.create(:plug)
    @api_device =  FactoryGirl.create(:api_device)
  end

  it 'allows update with a valid timestamp and signature' do
    timestamp = Time.now.utc.to_i.to_s
    url = '/api/v1/plugs'
    post url,
         { mac: @plug.mac_address }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+timestamp)  }
    expect(response.status).to eq(200)
    @plug.reload
    expect(@plug.registered).to be_truthy
  end

  it 'does not allow update with an  invalid timestamp and valid signature' do
    timestamp = 6.minutes.ago.utc.to_i.to_s
    url = '/api/v1/plugs'
    post url,
         { mac: @plug.mac_address }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+timestamp)  }
    expect(response.status).to eq(401)
  end

  it 'does not allow update with an  valid timestamp and invalid signature' do
    timestamp = Time.now.utc.to_i.to_s
    url = '/api/v1/plugs'
    post url,
         { mac: @plug.mac_address }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+'brokeen'+timestamp)  }
    expect(response.status).to eq(401)
  end

  it 'uses the secure key in the signature to get plug info' do
    timestamp = Time.now.utc.to_i.to_s

    url = '/api/v1/plugs'
    post url,
         { mac: @plug.mac_address }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+timestamp)  }
    expect(response.status).to eq(200)
    @plug.reload

    url = "/api/v1/plugs/#{@plug.id}"
    get url,
         nil,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+timestamp)  }
    expect(response.status).to eq(401)
    get url,
        nil,
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Timestamp' => timestamp, 'Signature' => Digest::MD5.hexdigest(url+timestamp+@plug.secure_key)  }
    expect(response.status).to eq(200)
  end

end