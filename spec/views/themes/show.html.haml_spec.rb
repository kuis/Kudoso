require 'rails_helper'

RSpec.describe "themes/show", type: :view do
  before(:each) do
    @theme = assign(:theme, Theme.create!(
      :name => "Name",
      :primary_color => "Primary Color",
      :secondary_color => "Secondary Color",
      :primary_bg_color => "Primary Bg Color",
      :secondard_bg_color => "Secondard Bg Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Primary Color/)
    expect(rendered).to match(/Secondary Color/)
    expect(rendered).to match(/Primary Bg Color/)
    expect(rendered).to match(/Secondard Bg Color/)
  end
end
