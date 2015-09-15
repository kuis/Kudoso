require 'rails_helper'

RSpec.describe "plugs/edit", type: :view do
  before(:each) do
    @plug = assign(:plug, Plug.create!(
      :mac_address => "MyString",
      :serial => "MyString",
      :secure_key => "MyString",
      :last_known_ip => "MyString",
      :deivce => ""
    ))
  end

  it "renders the edit plug form" do
    render

    assert_select "form[action=?][method=?]", plug_path(@plug), "post" do

      assert_select "input#plug_mac_address[name=?]", "plug[mac_address]"

      assert_select "input#plug_serial[name=?]", "plug[serial]"

      assert_select "input#plug_secure_key[name=?]", "plug[secure_key]"

      assert_select "input#plug_last_known_ip[name=?]", "plug[last_known_ip]"

      assert_select "input#plug_deivce[name=?]", "plug[deivce]"
    end
  end
end
