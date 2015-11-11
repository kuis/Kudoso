require 'rails_helper'

RSpec.describe RouterFirmware, type: :model do
  it 'has a valid factory' do
    resource = FactoryGirl.create(:router_firmware)
    expect(resource.valid?).to be_truthy
  end
end
