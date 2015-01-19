require 'rails_helper'

RSpec.describe ActivityType, :type => :model do
  it 'has a valid factory' do
    act_t = FactoryGirl.create(:activity_type)
    expect(act_t.valid?).to be_truthy
  end
end
