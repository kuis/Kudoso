require 'rails_helper'

RSpec.describe "content_ratings/index", :type => :view do
  before(:each) do
    assign(:content_ratings, [
      ContentRating.create!(
        :type => "Type",
        :tag => "Tag",
        :short => "Short",
        :description => "MyText"
      ),
      ContentRating.create!(
        :type => "Type",
        :tag => "Tag",
        :short => "Short",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of content_ratings" do
    render
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => "Tag".to_s, :count => 2
    assert_select "tr>td", :text => "Short".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
