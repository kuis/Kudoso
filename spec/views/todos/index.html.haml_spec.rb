require 'rails_helper'

RSpec.describe "todos/index", :type => :view do
  before(:each) do
    assign(:todos, [
      Todo.create!(
        :name => "Name",
        :description => "Description",
        :required => false,
        :kudos => 1,
        :todo_template_id => 2,
        :family_id => 3,
        :active => false,
        :schedule => "MyText"
      ),
      Todo.create!(
        :name => "Name",
        :description => "Description",
        :required => false,
        :kudos => 1,
        :todo_template_id => 2,
        :family_id => 3,
        :active => false,
        :schedule => "MyText"
      )
    ])
  end

  it "renders a list of todos" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
