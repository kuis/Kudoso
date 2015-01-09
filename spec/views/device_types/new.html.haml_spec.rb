require 'rails_helper'

RSpec.describe "device_types/new", :type => :view do
  before(:each) do
    assign(:device_type, DeviceType.new(
      :name => "MyString",
      :description => "MyString",
      :os => "MyString",
      :version => "MyString"
    ))
  end

  it "renders new device_type form" do
    render

    assert_select "form[action=?][method=?]", device_types_path, "post" do

      assert_select "input#device_type_name[name=?]", "device_type[name]"

      assert_select "input#device_type_description[name=?]", "device_type[description]"

      assert_select "input#device_type_os[name=?]", "device_type[os]"

      assert_select "input#device_type_version[name=?]", "device_type[version]"
    end
  end
end
