require 'rails_helper'

RSpec.describe Todo, :type => :model do
  it 'has a valid factory' do
    todo = FactoryGirl.create(:todo)
    expect(todo.valid?).to be_truthy
  end
end
