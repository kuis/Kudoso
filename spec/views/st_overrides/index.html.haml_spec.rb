require 'rails_helper'

RSpec.describe "st_overrides/index", :type => :view do
  before(:each) do
    assign(:st_overrides, [
      StOverride.create!(
        :member_id => 1,
        :created_by_id => 2,
        :time => 3,
        :comment => "Comment"
      ),
      StOverride.create!(
        :member_id => 1,
        :created_by_id => 2,
        :time => 3,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of st_overrides" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
