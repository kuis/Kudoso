require 'rails_helper'

RSpec.describe "activity_templates/index", :type => :view do
  before(:each) do
    assign(:activity_templates, [
      ActivityTemplate.create!(
        :name => "Name",
        :description => "Description",
        :rec_min_age => 1,
        :rec_max_age => 2,
        :cost => 3,
        :reward => 4,
        :time_block => 5,
        :restricted => false
      ),
      ActivityTemplate.create!(
        :name => "Name",
        :description => "Description",
        :rec_min_age => 1,
        :rec_max_age => 2,
        :cost => 3,
        :reward => 4,
        :time_block => 5,
        :restricted => false
      )
    ])
  end

  it "renders a list of activity_templates" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
