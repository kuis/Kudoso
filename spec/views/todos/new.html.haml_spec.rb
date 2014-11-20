require 'rails_helper'

RSpec.describe "todos/new", :type => :view do
  before(:each) do
    assign(:todo, Todo.new(
      :name => "MyString",
      :description => "MyString",
      :required => false,
      :kudos => 1,
      :todo_template_id => 1,
      :family_id => 1,
      :active => false,
      :schedule => "MyText"
    ))
  end

  it "renders new todo form" do
    render

    assert_select "form[action=?][method=?]", todos_path, "post" do

      assert_select "input#todo_name[name=?]", "todo[name]"

      assert_select "input#todo_description[name=?]", "todo[description]"

      assert_select "input#todo_required[name=?]", "todo[required]"

      assert_select "input#todo_kudos[name=?]", "todo[kudos]"

      assert_select "input#todo_todo_template_id[name=?]", "todo[todo_template_id]"

      assert_select "input#todo_family_id[name=?]", "todo[family_id]"

      assert_select "input#todo_active[name=?]", "todo[active]"

      assert_select "textarea#todo_schedule[name=?]", "todo[schedule]"
    end
  end
end
