require 'rails_helper'

RSpec.describe Activity, :type => :model do
  it 'has a valid factory' do
    act = FactoryGirl.create(:activity)
    expect(act.valid?).to be_truthy
  end

  it 'should not allow an activity if out of screen time' do
    @member = FactoryGirl.create(:member)
    device = FactoryGirl.create(:device, family_id: @member.family.id )
    @member.set_screen_time!(Date.today.wday, 0, device.id)
    family_activity = FactoryGirl.create(:family_activity, family_id: @member.family.id, device_types: [device.device_type] )
    act = @member.new_activity(family_activity, device)

    expect(act.valid?).to be_falsey
    expect(act.errors[:device].any?).to be_truthy

    @member.set_screen_time!(Date.today.wday, 3600, device.id)
    @member.set_screen_time!(Date.today.wday, 0, nil)

    act = @member.new_activity(family_activity, device)
    expect(act.valid?).to be_falsey
    expect(act.errors[:device].any?).to be_falsey
    expect(act.errors[:member].any?).to be_truthy


  end
end
