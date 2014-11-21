require 'rails_helper'

RSpec.describe "todo_schedules/index", :type => :view do
  before(:each) do
    assign(:todo_schedules, [
      TodoSchedule.create!(
        :todo_id => 1,
        :member_id => 2,
        :active => false,
        :schedule => "MyText",
        :notes => "MyText"
      ),
      TodoSchedule.create!(
        :todo_id => 1,
        :member_id => 2,
        :active => false,
        :schedule => "MyText",
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of todo_schedules" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
