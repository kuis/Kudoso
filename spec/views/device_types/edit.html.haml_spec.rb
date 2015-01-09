require 'rails_helper'

RSpec.describe "device_types/edit", :type => :view do
  before(:each) do
    @device_type = assign(:device_type, DeviceType.create!(
      :name => "MyString",
      :description => "MyString",
      :os => "MyString",
      :version => "MyString"
    ))
  end

  it "renders the edit device_type form" do
    render

    assert_select "form[action=?][method=?]", device_type_path(@device_type), "post" do

      assert_select "input#device_type_name[name=?]", "device_type[name]"

      assert_select "input#device_type_description[name=?]", "device_type[description]"

      assert_select "input#device_type_os[name=?]", "device_type[os]"

      assert_select "input#device_type_version[name=?]", "device_type[version]"
    end
  end
end
