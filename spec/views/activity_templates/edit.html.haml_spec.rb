require 'rails_helper'

RSpec.describe "activity_templates/edit", :type => :view do
  before(:each) do
    @activity_template = assign(:activity_template, ActivityTemplate.create!(
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

  it "renders the edit activity_template form" do
    render

    assert_select "form[action=?][method=?]", activity_template_path(@activity_template), "post" do

      assert_select "input#activity_template_name[name=?]", "activity_template[name]"

      assert_select "input#activity_template_description[name=?]", "activity_template[description]"

      assert_select "input#activity_template_rec_min_age[name=?]", "activity_template[rec_min_age]"

      assert_select "input#activity_template_rec_max_age[name=?]", "activity_template[rec_max_age]"

      assert_select "input#activity_template_cost[name=?]", "activity_template[cost]"

      assert_select "input#activity_template_reward[name=?]", "activity_template[reward]"

      assert_select "input#activity_template_time_block[name=?]", "activity_template[time_block]"

      assert_select "input#activity_template_restricted[name=?]", "activity_template[restricted]"
    end
  end
end
