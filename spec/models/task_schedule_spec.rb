require 'rails_helper'

RSpec.describe TaskSchedule, :type => :model do
  it 'has a valid factory' do
    task_s = FactoryGirl.create(:task_schedule)
    expect(task_s.valid?).to be_truthy
  end

  it 'returns a valid schedule object' do
    task_s = FactoryGirl.create(:task_schedule)
    expect(task_s.schedule.is_a?(IceCube::Schedule)).to be_truthy
  end

  it 'should require a start date to be valid' do
    task_s = FactoryGirl.create(:task_schedule)
    expect(task_s.valid?).to be_truthy

    task_s.start_date = nil
    expect(task_s.valid?).to be_falsey
    expect(task_s.errors[:start_date].any?).to be_truthy
  end

  it 'should allow daily recurring rules to be set' do
    task_s = FactoryGirl.create(:task_schedule, end_date: Date.today)
    task_s.schedule_rrules.each {|rr| rr.destroy}
    task_s.reload
    expect(task_s.schedule.occurs_on?(3.days.from_now)).to be_falsey
    task_s.update_attribute(:end_date, nil)
    rrule = FactoryGirl.create(:schedule_rrule, task_schedule_id: task_s.id)
    task_s.reload
    expect(task_s.schedule.occurs_on?(3.days.from_now)).to be_truthy
  end

end
