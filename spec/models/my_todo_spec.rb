require 'rails_helper'

RSpec.describe MyTodo, :type => :model do
  it 'has a valid factory' do
    my_todo = FactoryGirl.create(:my_todo)
    expect(my_todo.valid?).to be_truthy
  end
end
