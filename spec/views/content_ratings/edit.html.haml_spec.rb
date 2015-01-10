require 'rails_helper'

RSpec.describe "content_ratings/edit", :type => :view do
  before(:each) do
    @content_rating = assign(:content_rating, ContentRating.create!(
      :type => "",
      :tag => "MyString",
      :short => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit content_rating form" do
    render

    assert_select "form[action=?][method=?]", content_rating_path(@content_rating), "post" do

      assert_select "input#content_rating_type[name=?]", "content_rating[type]"

      assert_select "input#content_rating_tag[name=?]", "content_rating[tag]"

      assert_select "input#content_rating_short[name=?]", "content_rating[short]"

      assert_select "textarea#content_rating_description[name=?]", "content_rating[description]"
    end
  end
end
