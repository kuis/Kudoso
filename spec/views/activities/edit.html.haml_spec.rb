require 'rails_helper'

RSpec.describe "activities/edit", :type => :view do
  before(:each) do
    @activity = assign(:activity, Activity.create!(
      :activity_template_id => 1,
      :name => "MyString",
      :description => "MyString",
      :rec_min_age => 1,
      :rec_max_age => 1,
      :cost => 1,
      :reward => 1,
      :time_block => 1,
      :restricted => false
    ))
  end

  it "renders the edit activity form" do
    render

    assert_select "form[action=?][method=?]", activity_path(@activity), "post" do

      assert_select "input#activity_activity_template_id[name=?]", "activity[activity_template_id]"

      assert_select "input#activity_name[name=?]", "activity[name]"

      assert_select "input#activity_description[name=?]", "activity[description]"

      assert_select "input#activity_rec_min_age[name=?]", "activity[rec_min_age]"

      assert_select "input#activity_rec_max_age[name=?]", "activity[rec_max_age]"

      assert_select "input#activity_cost[name=?]", "activity[cost]"

      assert_select "input#activity_reward[name=?]", "activity[reward]"

      assert_select "input#activity_time_block[name=?]", "activity[time_block]"

      assert_select "input#activity_restricted[name=?]", "activity[restricted]"
    end
  end
end
