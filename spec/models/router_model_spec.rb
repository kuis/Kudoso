require 'rails_helper'

RSpec.describe RouterModel, type: :model do
  it 'has a valid factory' do
    resource = FactoryGirl.create(:router_model)
    expect(resource.valid?).to be_truthy
  end
end
