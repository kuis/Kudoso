require 'rails_helper'

RSpec.describe "activities/new", :type => :view do
  before(:each) do
    assign(:activity, Activity.new(
      :member_id => 1,
      :created_by => 1,
      :family_activity_id => 1,
      :device_id => 1,
      :content_id => 1,
      :allowed_time => 1,
      :activity_type_id => 1,
      :cost => 1,
      :reward => 1
    ))
  end

  it "renders new activity form" do
    render

    assert_select "form[action=?][method=?]", activities_path, "post" do

      assert_select "input#activity_member_id[name=?]", "activity[member_id]"

      assert_select "input#activity_created_by[name=?]", "activity[created_by]"

      assert_select "input#activity_family_activity_id[name=?]", "activity[family_activity_id]"

      assert_select "input#activity_device_id[name=?]", "activity[device_id]"

      assert_select "input#activity_content_id[name=?]", "activity[content_id]"

      assert_select "input#activity_allowed_time[name=?]", "activity[allowed_time]"

      assert_select "input#activity_activity_type_id[name=?]", "activity[activity_type_id]"

      assert_select "input#activity_cost[name=?]", "activity[cost]"

      assert_select "input#activity_reward[name=?]", "activity[reward]"
    end
  end
end
