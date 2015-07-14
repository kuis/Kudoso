require 'rails_helper'

RSpec.describe Device, :type => :model do
  it 'has a valid factory' do
    device = FactoryGirl.create(:device)
    expect(device.valid?).to be_truthy
    expect(device.uuid.length).to eq(36)
  end

  it 'returns the current active member' do
    member = FactoryGirl.create(:member)
    device = FactoryGirl.create(:device, family_id: member.family.id)
    activity = FactoryGirl.create(:activity, created_by_id: member.id, member_id: member.id, device_id: device.id, end_time: nil)

    device.reload
    expect(device.current_member).to eq(member)
  end

end
