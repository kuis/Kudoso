require 'rails_helper'

RSpec.describe "activities/index", :type => :view do
  before(:each) do
    assign(:activities, [
      Activity.create!(
        :member_id => 1,
        :created_by => 2,
        :family_activity_id => 3,
        :device_id => 4,
        :content_id => 5,
        :allowed_time => 6,
        :activity_type_id => 7,
        :cost => 8,
        :reward => 9
      ),
      Activity.create!(
        :member_id => 1,
        :created_by => 2,
        :family_activity_id => 3,
        :device_id => 4,
        :content_id => 5,
        :allowed_time => 6,
        :activity_type_id => 7,
        :cost => 8,
        :reward => 9
      )
    ])
  end

  it "renders a list of activities" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
    assert_select "tr>td", :text => 9.to_s, :count => 2
  end
end
