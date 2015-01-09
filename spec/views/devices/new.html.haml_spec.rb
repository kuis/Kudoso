require 'rails_helper'

RSpec.describe "devices/new", :type => :view do
  before(:each) do
    assign(:device, Device.new(
      :name => "MyString",
      :device_type_id => 1,
      :family_id => 1,
      :managed => false,
      :management_id => 1,
      :primary_member_id => 1
    ))
  end

  it "renders new device form" do
    render

    assert_select "form[action=?][method=?]", devices_path, "post" do

      assert_select "input#device_name[name=?]", "device[name]"

      assert_select "input#device_device_type_id[name=?]", "device[device_type_id]"

      assert_select "input#device_family_id[name=?]", "device[family_id]"

      assert_select "input#device_managed[name=?]", "device[managed]"

      assert_select "input#device_management_id[name=?]", "device[management_id]"

      assert_select "input#device_primary_member_id[name=?]", "device[primary_member_id]"
    end
  end
end
