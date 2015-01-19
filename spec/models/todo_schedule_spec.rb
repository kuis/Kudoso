require 'rails_helper'

RSpec.describe TodoSchedule, :type => :model do
  it 'has a valid factory' do
    todo_s = FactoryGirl.create(:todo_schedule)
    expect(todo_s.valid?).to be_truthy
  end
end
