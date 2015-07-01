require 'rails_helper'

RSpec.describe "partners/show", type: :view do
  before(:each) do
    @partner = assign(:partner, Partner.create!(
      :name => "Name",
      :description => "Description",
      :api_key => "Api Key"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Api Key/)
  end
end
