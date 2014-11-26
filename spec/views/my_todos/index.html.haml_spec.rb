require 'rails_helper'

RSpec.describe "my_todos/index", :type => :view do
  before(:each) do
    assign(:my_todos, [
      MyTodo.create!(
        :todo_schedule_id => 1,
        :member_id => 2,
        :complete => false,
        :verify => false,
        :verified_by => 3
      ),
      MyTodo.create!(
        :todo_schedule_id => 1,
        :member_id => 2,
        :complete => false,
        :verify => false,
        :verified_by => 3
      )
    ])
  end

  it "renders a list of my_todos" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
