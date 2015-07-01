require 'rails_helper'

RSpec.describe "partners/edit", type: :view do
  before(:each) do
    @partner = assign(:partner, Partner.create!(
      :name => "MyString",
      :description => "MyString",
      :api_key => "MyString"
    ))
  end

  it "renders the edit partner form" do
    render

    assert_select "form[action=?][method=?]", partner_path(@partner), "post" do

      assert_select "input#partner_name[name=?]", "partner[name]"

      assert_select "input#partner_description[name=?]", "partner[description]"

      assert_select "input#partner_api_key[name=?]", "partner[api_key]"
    end
  end
end
