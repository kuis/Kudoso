require 'rails_helper'

RSpec.describe "todo_groups/new", :type => :view do
  before(:each) do
    assign(:todo_group, TodoGroup.new(
      :name => "MyString",
      :rec_min_age => 1,
      :rec_max_age => 1,
      :active => false
    ))
  end

  it "renders new todo_group form" do
    render

    assert_select "form[action=?][method=?]", todo_groups_path, "post" do

      assert_select "input#todo_group_name[name=?]", "todo_group[name]"

      assert_select "input#todo_group_rec_min_age[name=?]", "todo_group[rec_min_age]"

      assert_select "input#todo_group_rec_max_age[name=?]", "todo_group[rec_max_age]"

      assert_select "input#todo_group_active[name=?]", "todo_group[active]"
    end
  end
end
