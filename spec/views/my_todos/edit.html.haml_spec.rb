require 'rails_helper'

RSpec.describe "my_todos/edit", :type => :view do
  before(:each) do
    @my_todo = assign(:my_todo, MyTodo.create!(
      :todo_schedule_id => 1,
      :member_id => 1,
      :complete => false,
      :verify => false,
      :verified_by => 1
    ))
  end

  it "renders the edit my_todo form" do
    render

    assert_select "form[action=?][method=?]", my_todo_path(@my_todo), "post" do

      assert_select "input#my_todo_todo_schedule_id[name=?]", "my_todo[todo_schedule_id]"

      assert_select "input#my_todo_member_id[name=?]", "my_todo[member_id]"

      assert_select "input#my_todo_complete[name=?]", "my_todo[complete]"

      assert_select "input#my_todo_verify[name=?]", "my_todo[verify]"

      assert_select "input#my_todo_verified_by[name=?]", "my_todo[verified_by]"
    end
  end
end
