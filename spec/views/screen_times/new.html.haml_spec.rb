require 'rails_helper'

RSpec.describe "screen_times/new", :type => :view do
  before(:each) do
    assign(:screen_time, ScreenTime.new(
      :member_id => 1,
      :device_id => 1,
      :dow => 1,
      :maxtime => 1
    ))
  end

  it "renders new screen_time form" do
    render

    assert_select "form[action=?][method=?]", screen_times_path, "post" do

      assert_select "input#screen_time_member_id[name=?]", "screen_time[member_id]"

      assert_select "input#screen_time_device_id[name=?]", "screen_time[device_id]"

      assert_select "input#screen_time_dow[name=?]", "screen_time[dow]"

      assert_select "input#screen_time_maxtime[name=?]", "screen_time[maxtime]"
    end
  end
end
