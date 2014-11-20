require 'rails_helper'

RSpec.describe "todo_templates/edit", :type => :view do
  before(:each) do
    @todo_template = assign(:todo_template, TodoTemplate.create!(
      :name => "MyString",
      :description => "MyString",
      :schedule => "MyString",
      :active => "MyString"
    ))
  end

  it "renders the edit todo_template form" do
    render

    assert_select "form[action=?][method=?]", todo_template_path(@todo_template), "post" do

      assert_select "input#todo_template_name[name=?]", "todo_template[name]"

      assert_select "input#todo_template_description[name=?]", "todo_template[description]"

      assert_select "input#todo_template_schedule[name=?]", "todo_template[schedule]"

      assert_select "input#todo_template_active[name=?]", "todo_template[active]"
    end
  end
end
