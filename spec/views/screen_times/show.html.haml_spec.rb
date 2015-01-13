require 'rails_helper'

RSpec.describe "screen_times/show", :type => :view do
  before(:each) do
    @screen_time = assign(:screen_time, ScreenTime.create!(
      :member_id => 1,
      :device_id => 2,
      :dow => 3,
      :maxtime => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
