require 'rails_helper'

RSpec.describe "contents/index", :type => :view do
  before(:each) do
    assign(:contents, [
      Content.create!(
        :content_type_id => 1,
        :title => "Title",
        :year => "Year",
        :content_rating_id => 2,
        :language_id => 3,
        :description => "MyText",
        :length => "Length",
        :metadata => "MyText",
        :references => "MyText"
      ),
      Content.create!(
        :content_type_id => 1,
        :title => "Title",
        :year => "Year",
        :content_rating_id => 2,
        :language_id => 3,
        :description => "MyText",
        :length => "Length",
        :metadata => "MyText",
        :references => "MyText"
      )
    ])
  end

  it "renders a list of contents" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Year".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Length".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
