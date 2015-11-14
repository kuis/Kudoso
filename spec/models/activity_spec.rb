require 'rails_helper'

RSpec.describe Activity, :type => :model do
  it 'has a valid factory' do
    act = FactoryGirl.create(:activity)
    expect(act.valid?).to be_truthy
  end

  it 'should not allow an activity to start if out of screen time' do
    @member = FactoryGirl.create(:member)
    device = FactoryGirl.create(:device, family_id: @member.family.id )
    activity_template = FactoryGirl.create(:activity_template )
    act = @member.new_activity(activity_template, device)


    @member.set_screen_time!(Date.today.wday, 3600, 4800, device.id) #device has time
    @member.set_screen_time!(Date.today.wday, 0, 3600, nil) # member does not

    expect{ act.start! }.to raise_error(Activity::ScreenTimeExceeded)

    expect(act.start_time).to be_nil

    act.reload
    act.valid? # resets errors...


    @member.set_screen_time!(Date.today.wday, 0, 4800, device.id) #device does not have time
    @member.set_screen_time!(Date.today.wday, 3600, 3600, nil) # member has time

    expect{ act.start! }.to raise_error(Activity::DeviceScreenTimeExceeded)

    expect(act.start_time).to be_nil
  end

  it 'should allow devices to be associated with activity' do
    @member = FactoryGirl.create(:member)
    devices = FactoryGirl.create_list(:device, 3, family_id: @member.family.id)
    activity_template = FactoryGirl.create(:activity_template )
    act = @member.new_activity(activity_template, devices)
    expect(act.devices).to match_array(devices)
  end

  it 'should allow deletion' do
    @member = FactoryGirl.create(:member)
    devices = FactoryGirl.create_list(:device, 3, family_id: @member.family.id)
    activity_template = FactoryGirl.create(:activity_template )
    act = @member.new_activity(activity_template, devices)
    expect(act.devices).to match_array(devices)
    act.destroy
  end

  it 'should not allow an activity to start if member does not have enough kudos' do
    @member = FactoryGirl.create(:member)
    activity_template = FactoryGirl.create(:activity_template, cost: @member.kudos + 100 )
    expect(activity_template.cost).to eq(@member.kudos + 100)
    act = @member.new_activity(activity_template, nil)
    expect{ act.start! }.to raise_error(Member::NotEnoughKudos)
  end
end
