require 'rails_helper'

RSpec.describe "devices/show", :type => :view do
  before(:each) do
    @device = assign(:device, Device.create!(
      :name => "Name",
      :device_type_id => 1,
      :family_id => 2,
      :managed => false,
      :management_id => 3,
      :primary_member_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
