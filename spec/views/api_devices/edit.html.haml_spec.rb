require 'rails_helper'

RSpec.describe "api_devices/edit", :type => :view do
  before(:each) do
    @api_device = assign(:api_device, ApiDevice.create!(
      :device_token => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit api_device form" do
    render

    assert_select "form[action=?][method=?]", api_device_path(@api_device), "post" do

      assert_select "input#api_device_device_token[name=?]", "api_device[device_token]"

      assert_select "input#api_device_name[name=?]", "api_device[name]"
    end
  end
end
