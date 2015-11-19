require 'rails_helper'

RSpec.describe Router, type: :model do
  it 'has a valid factory' do
    resource = FactoryGirl.create(:router)
    expect(resource.valid?).to be_truthy
  end
end
