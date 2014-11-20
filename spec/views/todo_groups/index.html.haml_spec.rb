require 'rails_helper'

RSpec.describe "todo_groups/index", :type => :view do
  before(:each) do
    assign(:todo_groups, [
      TodoGroup.create!(
        :name => "Name",
        :rec_min_age => 1,
        :rec_max_age => 2,
        :active => false
      ),
      TodoGroup.create!(
        :name => "Name",
        :rec_min_age => 1,
        :rec_max_age => 2,
        :active => false
      )
    ])
  end

  it "renders a list of todo_groups" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
