require 'rails_helper'

RSpec.describe "content_descriptors/new", :type => :view do
  before(:each) do
    assign(:content_descriptor, ContentDescriptor.new(
      :tag => "MyString",
      :short => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new content_descriptor form" do
    render

    assert_select "form[action=?][method=?]", content_descriptors_path, "post" do

      assert_select "input#content_descriptor_tag[name=?]", "content_descriptor[tag]"

      assert_select "input#content_descriptor_short[name=?]", "content_descriptor[short]"

      assert_select "textarea#content_descriptor_description[name=?]", "content_descriptor[description]"
    end
  end
end
