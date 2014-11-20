require 'rails_helper'

RSpec.describe "todo_templates/index", :type => :view do
  before(:each) do
    assign(:todo_templates, [
      TodoTemplate.create!(
        :name => "Name",
        :description => "Description",
        :schedule => "Schedule",
        :active => "Active"
      ),
      TodoTemplate.create!(
        :name => "Name",
        :description => "Description",
        :schedule => "Schedule",
        :active => "Active"
      )
    ])
  end

  it "renders a list of todo_templates" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Schedule".to_s, :count => 2
    assert_select "tr>td", :text => "Active".to_s, :count => 2
  end
end
