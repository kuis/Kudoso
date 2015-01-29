require 'rails_helper'

RSpec.describe ScheduleRrule, :type => :model do
  it 'has a valid factory' do
    rrule = FactoryGirl.create(:schedule_rrule)
    expect(rrule.valid?).to be_truthy
  end

  it 'stores and retrieves rules as yaml' do
    rrule = ScheduleRrule.new

    ice_rule = IceCube::Rule.daily.to_yaml

    rrule.rule = ice_rule
    expect(rrule.rrule).to eq(ice_rule)
    expect(rrule.rule).to eq(IceCube::Rule.from_yaml(ice_rule))


  end

  it 'should not save an invalid rule' do
    rrule = FactoryGirl.create(:schedule_rrule)
    rule = rrule.rule
    rrule.rule = 'wdfwdfwfd'
    rrule.reload
    expect(rrule.rule).to eq(rule)
    expect(rrule.errors.any?).to be_truthy
  end
end
