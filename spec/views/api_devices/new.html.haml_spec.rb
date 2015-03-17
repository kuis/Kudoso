require 'rails_helper'

RSpec.describe "api_devices/new", :type => :view do
  before(:each) do
    assign(:api_device, ApiDevice.new(
      :device_token => "MyString",
      :name => "MyString"
    ))
  end

  it "renders new api_device form" do
    render

    assert_select "form[action=?][method=?]", api_devices_path, "post" do

      assert_select "input#api_device_device_token[name=?]", "api_device[device_token]"

      assert_select "input#api_device_name[name=?]", "api_device[name]"
    end
  end
end
