require 'rails_helper'

RSpec.describe "activities/index", :type => :view do
  before(:each) do
    assign(:activities, [
      Activity.create!(
        :member_id => 1,
        :family_activity_id => 2,
        :date => "",
        :duration => 3,
        :device_id => 4,
        :notes => "MyText"
      ),
      Activity.create!(
        :member_id => 1,
        :family_activity_id => 2,
        :date => "",
        :duration => 3,
        :device_id => 4,
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of activities" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
