require 'rails_helper'

RSpec.describe Device, :type => :model do
  it 'has a valid factory' do
    device = FactoryGirl.create(:device)
    expect(device.valid?).to be_truthy
  end

end
