require 'rails_helper'

RSpec.describe Partner, type: :model do
  it 'has a valid factory' do
    partner = FactoryGirl.create(:partner)
    expect(partner.valid?).to be_truthy
    expect(partner.api_key.present?).to be_truthy
  end
end
