require 'rails_helper'

RSpec.describe Activity, :type => :model do
  it 'has a valid factory' do
    act = FactoryGirl.create(:activity)
    expect(act.valid?).to be_truthy
  end
end
