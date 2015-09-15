require 'rails_helper'

RSpec.describe "plugs/index", type: :view do
  before(:each) do
    assign(:plugs, [
      Plug.create!(
        :mac_address => "Mac Address",
        :serial => "Serial",
        :secure_key => "Secure Key",
        :last_known_ip => "Last Known Ip",
        :deivce => ""
      ),
      Plug.create!(
        :mac_address => "Mac Address",
        :serial => "Serial",
        :secure_key => "Secure Key",
        :last_known_ip => "Last Known Ip",
        :deivce => ""
      )
    ])
  end

  it "renders a list of plugs" do
    render
    assert_select "tr>td", :text => "Mac Address".to_s, :count => 2
    assert_select "tr>td", :text => "Serial".to_s, :count => 2
    assert_select "tr>td", :text => "Secure Key".to_s, :count => 2
    assert_select "tr>td", :text => "Last Known Ip".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
