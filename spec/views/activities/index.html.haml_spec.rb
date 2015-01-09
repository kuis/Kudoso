require 'rails_helper'

RSpec.describe "activities/index", :type => :view do
  before(:each) do
    assign(:activities, [
      Activity.create!(
        :activity_template_id => 1,
        :name => "Name",
        :description => "Description",
        :rec_min_age => 2,
        :rec_max_age => 3,
        :cost => 4,
        :reward => 5,
        :time_block => 6,
        :restricted => false
      ),
      Activity.create!(
        :activity_template_id => 1,
        :name => "Name",
        :description => "Description",
        :rec_min_age => 2,
        :rec_max_age => 3,
        :cost => 4,
        :reward => 5,
        :time_block => 6,
        :restricted => false
      )
    ])
  end

  it "renders a list of activities" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
