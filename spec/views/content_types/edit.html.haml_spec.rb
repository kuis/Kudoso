require 'rails_helper'

RSpec.describe "content_types/edit", :type => :view do
  before(:each) do
    @content_type = assign(:content_type, ContentType.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit content_type form" do
    render

    assert_select "form[action=?][method=?]", content_type_path(@content_type), "post" do

      assert_select "input#content_type_name[name=?]", "content_type[name]"
    end
  end
end
