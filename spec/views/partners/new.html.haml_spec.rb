require 'rails_helper'

RSpec.describe "partners/new", type: :view do
  before(:each) do
    assign(:partner, Partner.new(
      :name => "MyString",
      :description => "MyString",
      :api_key => "MyString"
    ))
  end

  it "renders new partner form" do
    render

    assert_select "form[action=?][method=?]", partners_path, "post" do

      assert_select "input#partner_name[name=?]", "partner[name]"

      assert_select "input#partner_description[name=?]", "partner[description]"

      assert_select "input#partner_api_key[name=?]", "partner[api_key]"
    end
  end
end
