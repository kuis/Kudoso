require 'rails_helper'

RSpec.describe TodoTemplate, :type => :model do
  it 'has a valid factory' do
    todo_t = FactoryGirl.create(:todo_template)
    expect(todo_t.valid?).to be_truthy
  end
end
