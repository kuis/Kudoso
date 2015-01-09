require 'rails_helper'

RSpec.describe "family_activities/new", :type => :view do
  before(:each) do
    assign(:family_activity, FamilyActivity.new(
      :family_id => 1,
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

  it "renders new family_activity form" do
    render

    assert_select "form[action=?][method=?]", family_activities_path, "post" do

      assert_select "input#family_activity_family_id[name=?]", "family_activity[family_id]"

      assert_select "input#family_activity_activity_template_id[name=?]", "family_activity[activity_template_id]"

      assert_select "input#family_activity_name[name=?]", "family_activity[name]"

      assert_select "input#family_activity_description[name=?]", "family_activity[description]"

      assert_select "input#family_activity_rec_min_age[name=?]", "family_activity[rec_min_age]"

      assert_select "input#family_activity_rec_max_age[name=?]", "family_activity[rec_max_age]"

      assert_select "input#family_activity_cost[name=?]", "family_activity[cost]"

      assert_select "input#family_activity_reward[name=?]", "family_activity[reward]"

      assert_select "input#family_activity_time_block[name=?]", "family_activity[time_block]"

      assert_select "input#family_activity_restricted[name=?]", "family_activity[restricted]"
    end
  end
end
