require 'rails_helper'

RSpec.describe "themes/edit", type: :view do
  before(:each) do
    @theme = assign(:theme, Theme.create!(
      :name => "MyString",
      :primary_color => "MyString",
      :secondary_color => "MyString",
      :primary_bg_color => "MyString",
      :secondard_bg_color => "MyString"
    ))
  end

  it "renders the edit theme form" do
    render

    assert_select "form[action=?][method=?]", theme_path(@theme), "post" do

      assert_select "input#theme_name[name=?]", "theme[name]"

      assert_select "input#theme_primary_color[name=?]", "theme[primary_color]"

      assert_select "input#theme_secondary_color[name=?]", "theme[secondary_color]"

      assert_select "input#theme_primary_bg_color[name=?]", "theme[primary_bg_color]"

      assert_select "input#theme_secondard_bg_color[name=?]", "theme[secondard_bg_color]"
    end
  end
end
