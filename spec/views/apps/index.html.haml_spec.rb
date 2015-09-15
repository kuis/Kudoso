require 'rails_helper'

RSpec.describe "apps/index", type: :view do
  before(:each) do
    assign(:apps, [
      App.create!(
        :name => "Name",
        :bundle_identifier => "Bundle Identifier",
        :publisher => "Publisher",
        :url => "Url"
      ),
      App.create!(
        :name => "Name",
        :bundle_identifier => "Bundle Identifier",
        :publisher => "Publisher",
        :url => "Url"
      )
    ])
  end

  it "renders a list of apps" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Bundle Identifier".to_s, :count => 2
    assert_select "tr>td", :text => "Publisher".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
  end
end
