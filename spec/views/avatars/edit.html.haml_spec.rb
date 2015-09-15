require 'rails_helper'

RSpec.describe "avatars/edit", type: :view do
  before(:each) do
    @avatar = assign(:avatar, Avatar.create!(
      :name => "MyString",
      :gender => "MyString",
      :theme_id => 1
    ))
  end

  it "renders the edit avatar form" do
    render

    assert_select "form[action=?][method=?]", avatar_path(@avatar), "post" do

      assert_select "input#avatar_name[name=?]", "avatar[name]"

      assert_select "input#avatar_gender[name=?]", "avatar[gender]"

      assert_select "input#avatar_theme_id[name=?]", "avatar[theme_id]"
    end
  end
end
