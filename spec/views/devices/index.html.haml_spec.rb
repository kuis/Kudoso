require 'rails_helper'

RSpec.describe "devices/index", :type => :view do
  before(:each) do
    assign(:devices, [
      Device.create!(
        :name => "Name",
        :device_type_id => 1,
        :family_id => 2,
        :managed => false,
        :management_id => 3,
        :primary_member_id => 4
      ),
      Device.create!(
        :name => "Name",
        :device_type_id => 1,
        :family_id => 2,
        :managed => false,
        :management_id => 3,
        :primary_member_id => 4
      )
    ])
  end

  it "renders a list of devices" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
