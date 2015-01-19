require 'rails_helper'

RSpec.describe ScheduleRrule, :type => :model do
  it 'has a valid factory' do
    rrule = FactoryGirl.create(:schedule_rrule)
    expect(rrule.valid?).to be_truthy
  end
end
