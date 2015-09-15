require 'rails_helper'

RSpec.describe "avatars/index", type: :view do
  before(:each) do
    assign(:avatars, [
      Avatar.create!(
        :name => "Name",
        :gender => "Gender",
        :theme_id => 1
      ),
      Avatar.create!(
        :name => "Name",
        :gender => "Gender",
        :theme_id => 1
      )
    ])
  end

  it "renders a list of avatars" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gender".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
