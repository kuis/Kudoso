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
end
