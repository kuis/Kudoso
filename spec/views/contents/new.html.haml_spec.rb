require 'rails_helper'

RSpec.describe "contents/new", :type => :view do
  before(:each) do
    assign(:content, Content.new(
      :content_type_id => 1,
      :title => "MyString",
      :year => "MyString",
      :content_rating_id => 1,
      :language_id => 1,
      :description => "MyText",
      :length => "MyString",
      :metadata => "MyText",
      :references => "MyText"
    ))
  end

  it "renders new content form" do
    render

    assert_select "form[action=?][method=?]", contents_path, "post" do

      assert_select "input#content_content_type_id[name=?]", "content[content_type_id]"

      assert_select "input#content_title[name=?]", "content[title]"

      assert_select "input#content_year[name=?]", "content[year]"

      assert_select "input#content_content_rating_id[name=?]", "content[content_rating_id]"

      assert_select "input#content_language_id[name=?]", "content[language_id]"

      assert_select "textarea#content_description[name=?]", "content[description]"

      assert_select "input#content_length[name=?]", "content[length]"

      assert_select "textarea#content_metadata[name=?]", "content[metadata]"

      assert_select "textarea#content_references[name=?]", "content[references]"
    end
  end
end
