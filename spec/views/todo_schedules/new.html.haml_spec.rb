require 'rails_helper'

RSpec.describe "todo_schedules/new", :type => :view do
  before(:each) do
    assign(:todo_schedule, TodoSchedule.new(
      :todo_id => 1,
      :member_id => 1,
      :active => false,
      :schedule => "MyText",
      :notes => "MyText"
    ))
  end

  it "renders new todo_schedule form" do
    render

    assert_select "form[action=?][method=?]", todo_schedules_path, "post" do

      assert_select "input#todo_schedule_todo_id[name=?]", "todo_schedule[todo_id]"

      assert_select "input#todo_schedule_member_id[name=?]", "todo_schedule[member_id]"

      assert_select "input#todo_schedule_active[name=?]", "todo_schedule[active]"

      assert_select "textarea#todo_schedule_schedule[name=?]", "todo_schedule[schedule]"

      assert_select "textarea#todo_schedule_notes[name=?]", "todo_schedule[notes]"
    end
  end
end
