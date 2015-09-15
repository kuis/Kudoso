require 'rails_helper'

RSpec.describe "avatars/new", type: :view do
  before(:each) do
    assign(:avatar, Avatar.new(
      :name => "MyString",
      :gender => "MyString",
      :theme_id => 1
    ))
  end

  it "renders new avatar form" do
    render

    assert_select "form[action=?][method=?]", avatars_path, "post" do

      assert_select "input#avatar_name[name=?]", "avatar[name]"

      assert_select "input#avatar_gender[name=?]", "avatar[gender]"

      assert_select "input#avatar_theme_id[name=?]", "avatar[theme_id]"
    end
  end
end
