require 'rails_helper'

RSpec.describe TodoGroup, :type => :model do
  it 'has a valid factory' do
    todo_group = FactoryGirl.create(:todo_group)
    expect(todo_group.valid?).to be_truthy
  end
end
