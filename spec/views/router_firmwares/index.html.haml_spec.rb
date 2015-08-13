require 'rails_helper'

RSpec.describe "router_firmwares/index", type: :view do
  before(:each) do
    assign(:router_firmwares, [
      RouterFirmware.create!(
        :router_model_id => 1,
        :version => "Version",
        :url => "Url",
        :notes => "MyText"
      ),
      RouterFirmware.create!(
        :router_model_id => 1,
        :version => "Version",
        :url => "Url",
        :notes => "MyText"
      )
    ])
  end

  it "renders a list of router_firmwares" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
