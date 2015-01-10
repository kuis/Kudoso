require 'rails_helper'

RSpec.describe "content_ratings/new", :type => :view do
  before(:each) do
    assign(:content_rating, ContentRating.new(
      :type => "",
      :tag => "MyString",
      :short => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new content_rating form" do
    render

    assert_select "form[action=?][method=?]", content_ratings_path, "post" do

      assert_select "input#content_rating_type[name=?]", "content_rating[type]"

      assert_select "input#content_rating_tag[name=?]", "content_rating[tag]"

      assert_select "input#content_rating_short[name=?]", "content_rating[short]"

      assert_select "textarea#content_rating_description[name=?]", "content_rating[description]"
    end
  end
end
