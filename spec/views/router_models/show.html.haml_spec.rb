require 'rails_helper'

RSpec.describe "router_models/show", type: :view do
  before(:each) do
    @router_model = assign(:router_model, RouterModel.create!(
      :name => "Name",
      :num => "Num"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Num/)
  end
end
