require 'rails_helper'

RSpec.describe "api_devices/show", :type => :view do
  before(:each) do
    @api_device = assign(:api_device, ApiDevice.create!(
      :device_token => "Device Token",
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Device Token/)
    expect(rendered).to match(/Name/)
  end
end
