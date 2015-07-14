require 'rails_helper'

RSpec.describe ActivityTemplate, :type => :model do
  it 'has a valid factory' do
    act_temp = FactoryGirl.create(:activity_template)
    expect(act_temp.valid?).to be_truthy
  end

  it 'should not delete but disabled on destroy' do

  end
end
