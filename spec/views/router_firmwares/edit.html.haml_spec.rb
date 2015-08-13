require 'rails_helper'

RSpec.describe "router_firmwares/edit", type: :view do
  before(:each) do
    @router_firmware = assign(:router_firmware, RouterFirmware.create!(
      :router_model_id => 1,
      :version => "MyString",
      :url => "MyString",
      :notes => "MyText"
    ))
  end

  it "renders the edit router_firmware form" do
    render

    assert_select "form[action=?][method=?]", router_firmware_path(@router_firmware), "post" do

      assert_select "input#router_firmware_router_model_id[name=?]", "router_firmware[router_model_id]"

      assert_select "input#router_firmware_version[name=?]", "router_firmware[version]"

      assert_select "input#router_firmware_url[name=?]", "router_firmware[url]"

      assert_select "textarea#router_firmware_notes[name=?]", "router_firmware[notes]"
    end
  end
end
