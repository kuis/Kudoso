require 'rails_helper'

RSpec.describe StOverride, :type => :model do
  it 'has a valid factory' do
    st_override = FactoryGirl.create(:st_override)
    expect(st_override.valid?).to be_truthy
  end

  it 'only allows positive times between 0 and 86400 seconds' do
    st_override = FactoryGirl.create(:st_override)
    st_override.time = 0
    expect(st_override.valid?).to be_truthy
    st_override.time = 24*60*60
    expect(st_override.valid?).to be_truthy
    st_override.time = -10
    expect(st_override.valid?).to be_falsey
    st_override.time = 24*60*60+1
    expect(st_override.valid?).to be_falsey
  end

  it 'returns st overides for the scope today' do
    st_overrides = FactoryGirl.create_list(:st_override, 5)
    st_overrides = FactoryGirl.create_list(:st_override, 5, date: Time.now+1.day)
    st_overrides = FactoryGirl.create_list(:st_override, 5, date: Time.now+2.days)

    expect(StOverride.today.count).to eq(5)
  end
end
