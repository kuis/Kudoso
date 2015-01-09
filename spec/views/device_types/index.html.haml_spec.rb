require 'rails_helper'

RSpec.describe "device_types/index", :type => :view do
  before(:each) do
    assign(:device_types, [
      DeviceType.create!(
        :name => "Name",
        :description => "Description",
        :os => "Os",
        :version => "Version"
      ),
      DeviceType.create!(
        :name => "Name",
        :description => "Description",
        :os => "Os",
        :version => "Version"
      )
    ])
  end

  it "renders a list of device_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Os".to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
  end
end
