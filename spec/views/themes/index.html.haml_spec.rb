require 'rails_helper'

RSpec.describe "themes/index", type: :view do
  before(:each) do
    assign(:themes, [
      Theme.create!(
        :name => "Name",
        :primary_color => "Primary Color",
        :secondary_color => "Secondary Color",
        :primary_bg_color => "Primary Bg Color",
        :secondard_bg_color => "Secondard Bg Color"
      ),
      Theme.create!(
        :name => "Name",
        :primary_color => "Primary Color",
        :secondary_color => "Secondary Color",
        :primary_bg_color => "Primary Bg Color",
        :secondard_bg_color => "Secondard Bg Color"
      )
    ])
  end

  it "renders a list of themes" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Primary Color".to_s, :count => 2
    assert_select "tr>td", :text => "Secondary Color".to_s, :count => 2
    assert_select "tr>td", :text => "Primary Bg Color".to_s, :count => 2
    assert_select "tr>td", :text => "Secondard Bg Color".to_s, :count => 2
  end
end
