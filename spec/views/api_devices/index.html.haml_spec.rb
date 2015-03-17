require 'rails_helper'

RSpec.describe "api_devices/index", :type => :view do
  before(:each) do
    assign(:api_devices, [
      ApiDevice.create!(
        :device_token => "Device Token",
        :name => "Name"
      ),
      ApiDevice.create!(
        :device_token => "Device Token",
        :name => "Name"
      )
    ])
  end

  it "renders a list of api_devices" do
    render
    assert_select "tr>td", :text => "Device Token".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
