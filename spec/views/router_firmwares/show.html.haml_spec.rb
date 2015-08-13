require 'rails_helper'

RSpec.describe "router_firmwares/show", type: :view do
  before(:each) do
    @router_firmware = assign(:router_firmware, RouterFirmware.create!(
      :router_model_id => 1,
      :version => "Version",
      :url => "Url",
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Version/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/MyText/)
  end
end
