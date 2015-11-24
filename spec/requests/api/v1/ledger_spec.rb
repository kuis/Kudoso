# spec/requests/api/v1/ledger_spec.rb

require 'rails_helper'

describe 'Ledger API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    #@member = FactoryGirl.create(:member, family_id: @user.member.family.id)
    @member = Member.create(username: 'thetest', password: 'password', password_confirmation: 'password', birth_date: 10.years.ago, family_id: @user.family_id)
    @api_device =  FactoryGirl.create(:api_device)
    @member.reload


    @member.credit_kudos(1000, 'Initial Balance')
    10.times do |idx|
      if rand(2) == 1
        @member.debit_kudos(rand(10)*10, "Entry on idx #{idx}")
      else
        @member.credit_kudos(rand(10)*10, "Entry on idx #{idx}")
      end
    end
    @member.password = 'password'
    @member.password_confirmation = 'password'
    @member.save
    @member.reload
    post '/api/v1/sessions',
         { device_token: @api_device.device_token, family_id: @member.family_id, username: @member.username, password: Digest::MD5.hexdigest('password' + @member.family.secure_key ).to_s }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'returns ledger entries' do
    get "/api/v1/families/#{@user.family.id}/members/#{@member.id}/ledger",
         nil,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["ledger_entries"].present?).to be_truthy
    expect(json["ledger_entries"].length).to eq(11)
  end

end
