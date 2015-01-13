require 'rails_helper'

RSpec.describe "screen_times/edit", :type => :view do
  before(:each) do
    @screen_time = assign(:screen_time, ScreenTime.create!(
      :member_id => 1,
      :device_id => 1,
      :dow => 1,
      :maxtime => 1
    ))
  end

  it "renders the edit screen_time form" do
    render

    assert_select "form[action=?][method=?]", screen_time_path(@screen_time), "post" do

      assert_select "input#screen_time_member_id[name=?]", "screen_time[member_id]"

      assert_select "input#screen_time_device_id[name=?]", "screen_time[device_id]"

      assert_select "input#screen_time_dow[name=?]", "screen_time[dow]"

      assert_select "input#screen_time_maxtime[name=?]", "screen_time[maxtime]"
    end
  end
end
