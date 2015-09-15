require 'rails_helper'

RSpec.describe "plugs/show", type: :view do
  before(:each) do
    @plug = assign(:plug, Plug.create!(
      :mac_address => "Mac Address",
      :serial => "Serial",
      :secure_key => "Secure Key",
      :last_known_ip => "Last Known Ip",
      :deivce => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Mac Address/)
    expect(rendered).to match(/Serial/)
    expect(rendered).to match(/Secure Key/)
    expect(rendered).to match(/Last Known Ip/)
    expect(rendered).to match(//)
  end
end
