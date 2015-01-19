require 'rails_helper'

RSpec.describe DeviceType, :type => :model do
  it 'has a valid factory' do
    device_t = FactoryGirl.create(:device_type)
    expect(device_t.valid?).to be_truthy
  end
end
