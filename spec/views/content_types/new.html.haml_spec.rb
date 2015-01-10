require 'rails_helper'

RSpec.describe "content_types/new", :type => :view do
  before(:each) do
    assign(:content_type, ContentType.new(
      :name => "MyString"
    ))
  end

  it "renders new content_type form" do
    render

    assert_select "form[action=?][method=?]", content_types_path, "post" do

      assert_select "input#content_type_name[name=?]", "content_type[name]"
    end
  end
end
