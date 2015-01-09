require 'rails_helper'

RSpec.describe "device_types/show", :type => :view do
  before(:each) do
    @device_type = assign(:device_type, DeviceType.create!(
      :name => "Name",
      :description => "Description",
      :os => "Os",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Os/)
    expect(rendered).to match(/Version/)
  end
end
