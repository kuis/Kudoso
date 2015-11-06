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

    act.start!

    expect(act.start_time).to be_nil
    expect(act.errors[:member].any?).to be_truthy
    expect(act.errors[:device].any?).to be_falsey

    act.reload
    act.valid? # resets errors...


    @member.set_screen_time!(Date.today.wday, 0, 4800, device.id) #device does not have time
    @member.set_screen_time!(Date.today.wday, 3600, 3600, nil) # member has time

    act.start!


    expect(act.start_time).to be_nil
    expect(act.errors[:member].any?).to be_falsey
    expect(act.errors[:device].any?).to be_truthy
  end
end
