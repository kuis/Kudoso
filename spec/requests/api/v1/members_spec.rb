# spec/requests/api/v1/members_spec.rb

require 'rails_helper'

describe 'Members API', type: :request do
  before(:all) do
    @user = FactoryGirl.create(:user)
    @members = FactoryGirl.create_list(:member, 3, family_id: @user.member.family.id)
    @device =  FactoryGirl.create(:api_device)
    post '/api/v1/sessions', { device_token: @device.device_token, email: @user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
  end

  it 'admin user returns the member list for a family' do
    admin_user = FactoryGirl.create(:user, admin: true)
    post '/api/v1/sessions', { device_token: @device.device_token, email: admin_user.email, password: 'password'}.to_json,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    json = JSON.parse(response.body)
    family = FactoryGirl.create(:family)
    members = FactoryGirl.create_list(:member, 3, family_id: family.id)
    get "/api/v1/families/#{family.id}/members", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{json["token"]}\"" }
    json = JSON.parse(response.body)
    expect(json["members"].length).to eq(members.count)
  end


  it 'returns members info for users family' do
    get "/api/v1/families/#{@user.member.family.id}/members", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["members"].length).to eq(@members.count + 1) #the original user is a member as well
  end

  it 'denies access to info for other users family' do
    other_user = FactoryGirl.create(:user)
    other_members = FactoryGirl.create_list(:member, 3, family_id: other_user.member.family.id)
    get "/api/v1/families/#{other_user.member.family.id}/members", nil,  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\"" }
    expect(response.status).to eq(403)
  end

  it 'returns limited member info for family if not authenticated' do
    other_user = FactoryGirl.create(:user)
    other_members = FactoryGirl.create_list(:member, 3, family_id: other_user.member.family.id)
    get "/api/v1/families/#{other_user.member.family.id}/members", { secure_key: other_user.family.secure_key },  { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["members"].first.has_key?("username")).to be_truthy
    expect(json["members"].first.has_key?("first_name")).to be_truthy
    expect(json["members"].first.has_key?("parent")).to be_truthy
    expect(json["members"].first.has_key?("theme")).to be_truthy
    expect(json["members"].first.has_key?("avatar_urls")).to be_truthy
    expect(json["members"].first.has_key?("birth_date")).to be_falsey
    expect(json["members"].first.has_key?("last_name")).to be_falsey
    expect(json["members"].first.has_key?("age")).to be_falsey
  end

  it 'creates a new family member' do
    prev = @user.family.members.count
    post "/api/v1/families/#{@user.family.id}/members",
         { member: { username: "dave", email: "dave@example.com", first_name: "dave", last_name: @user.last_name, password: 'password', password_confirmation: 'password', birth_date: "7/4/2001"} }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    @user.reload
    expect(@user.family.members.count).to eq(prev+1)
    member = @user.family.members.where(username: 'dave').first
    password_hash =  Digest::MD5.hexdigest('password' + @user.family.secure_key).to_s
    expect(member.valid_password?(password_hash)).to be_truthy
  end

  it 'updates a family member information' do
    member = @members.sample
    original_birth_date = member.birth_date
    patch "/api/v1/families/#{@user.family.id}/members/#{member.id}",
         { member: { birth_date: "7/4/2002"} }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    member.reload
    expect(member.birth_date).not_to eq(original_birth_date)
  end

  it 'returns member information' do
    member = @members.sample
    get "/api/v1/families/#{@user.family.id}/members/#{member.id}",
          nil,
          { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    expect(json["member"]["id"]).to eq(member.id)
  end

  it 'destroys member information' do
    member = @members.sample
    delete "/api/v1/families/#{@user.family.id}/members/#{member.id}",
        nil,
        { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    expect(@user.family.members.include?(member)).to be_falsey
  end

  it 'allows a member to buy screen time' do
    at = FactoryGirl.create(:activity_template)
    @member = @members.sample
    @member.password = 'password'
    @member.password_confirmation = 'password'
    @member.kudos = 10000
    @member.save
    expect(@member.available_screen_time < @member.max_screen_time).to be_truthy
    post '/api/v1/sessions',
         { device_token: @device.device_token, family_id: @member.family_id, username: @member.username, password: Digest::MD5.hexdigest('password' + @member.family.secure_key ).to_s }.to_json,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @token = json["token"]
    post "/api/v1/families/#{@user.family.id}/members/#{@member.id}/buy_screen_time",
         nil,
         { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json', 'Authorization' => "Token token=\"#{@token}\""  }
    expect(response.status).to eq(200)
    json = JSON.parse(response.body)
    @member.reload
    expect(json["member"]["screen_time"]).to eq(@member.max_screen_time)
  end

end
