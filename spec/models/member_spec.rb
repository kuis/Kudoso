require 'rails_helper'

RSpec.describe Member, :type => :model do
  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it 'has a valid factory' do
    expect(@member.valid?).to be_truthy
  end

  it 'should not allow duplicate usernames within a fmaily' do
    member_2 = Member.new(first_name: @member.first_name, username: @member.username, family_id: @member.family_id)
    expect(member_2.valid?).to be_falsey
    expect(member_2.errors[:username].any?).to be_truthy
  end

  it 'should return available screen time' do
    expect(@member.get_available_screen_time).to eq(60*60*24) # 24 hours in seconds

    @member.set_screen_time!(Date.today.wday, 3600)
    expect(@member.get_available_screen_time).to eq(3600)

    device = FactoryGirl.create(:device, family_id: @member.family.id )
    @member.set_screen_time!(Date.today.wday, 1800, device.id)
    expect(@member.get_available_screen_time).to eq(3600)
    expect(@member.get_available_screen_time(Date.today, device.id)).to eq(1800)
  end

  it 'should record activities as screen time' do
    device = FactoryGirl.create(:device, family_id: @member.family.id )
    start_time = @member.get_available_screen_time(Date.today, device.id)
    family_activity = FactoryGirl.create(:family_activity, family_id: @member.family.id, device_types: [device.device_type] )
    act = @member.new_activity(family_activity, device)
    act.start!
    sleep(5)
    act.stop!
    end_time = @member.get_available_screen_time(Date.today, device.id)
    used_time = @member.get_used_screen_time(Date.today, device.id)
    expect(used_time).to eq(act.duration)
    expect(used_time).to eq(start_time-end_time)
  end


end
