require 'rails_helper'

RSpec.describe ActivityDetail, :type => :model do
  it 'has a valid factory' do
    act_detail = FactoryGirl.create(:activity_detail)
    expect(act_detail.valid?).to be_truthy
  end
end
