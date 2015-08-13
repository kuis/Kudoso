require 'rails_helper'

RSpec.describe "router_models/index", type: :view do
  before(:each) do
    assign(:router_models, [
      RouterModel.create!(
        :name => "Name",
        :num => "Num"
      ),
      RouterModel.create!(
        :name => "Name",
        :num => "Num"
      )
    ])
  end

  it "renders a list of router_models" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Num".to_s, :count => 2
  end
end
