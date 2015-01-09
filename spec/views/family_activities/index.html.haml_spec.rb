require 'rails_helper'

RSpec.describe "family_activities/index", :type => :view do
  before(:each) do
    assign(:family_activities, [
      FamilyActivity.create!(
        :family_id => 1,
        :activity_template_id => 2,
        :name => "Name",
        :description => "Description",
        :rec_min_age => 3,
        :rec_max_age => 4,
        :cost => 5,
        :reward => 6,
        :time_block => 7,
        :restricted => false
      ),
      FamilyActivity.create!(
        :family_id => 1,
        :activity_template_id => 2,
        :name => "Name",
        :description => "Description",
        :rec_min_age => 3,
        :rec_max_age => 4,
        :cost => 5,
        :reward => 6,
        :time_block => 7,
        :restricted => false
      )
    ])
  end

  it "renders a list of family_activities" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
