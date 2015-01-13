require 'rails_helper'

RSpec.describe "screen_times/index", :type => :view do
  before(:each) do
    assign(:screen_times, [
      ScreenTime.create!(
        :member_id => 1,
        :device_id => 2,
        :dow => 3,
        :maxtime => 4
      ),
      ScreenTime.create!(
        :member_id => 1,
        :device_id => 2,
        :dow => 3,
        :maxtime => 4
      )
    ])
  end

  it "renders a list of screen_times" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
