require 'rails_helper'

RSpec.describe TodoSchedule, :type => :model do
  it 'has a valid factory' do
    todo_s = FactoryGirl.create(:todo_schedule)
    expect(todo_s.valid?).to be_truthy
  end

  it 'returns a valid schedule object' do
    todo_s = FactoryGirl.create(:todo_schedule)
    expect(todo_s.schedule.is_a?(IceCube::Schedule)).to be_truthy
  end

  it 'should require a start date to be valid' do
    todo_s = FactoryGirl.create(:todo_schedule)
    expect(todo_s.valid?).to be_truthy

    todo_s.start_date = nil
    expect(todo_s.valid?).to be_falsey
    expect(todo_s.errors[:start_date].any?).to be_truthy
  end

  it 'should allow daily recurring rules to be set' do
    todo_s = FactoryGirl.create(:todo_schedule, end_date: Date.today)
    todo_s.schedule_rrules.each {|rr| rr.destroy}
    todo_s.reload
    expect(todo_s.schedule.occurs_on?(3.days.from_now)).to be_falsey
    todo_s.update_attribute(:end_date, nil)
    rrule = FactoryGirl.create(:schedule_rrule, todo_schedule_id: todo_s.id)
    todo_s.reload
    expect(todo_s.schedule.occurs_on?(3.days.from_now)).to be_truthy
  end

end
