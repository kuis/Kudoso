require 'rails_helper'

RSpec.describe "partners/index", type: :view do
  before(:each) do
    assign(:partners, [
      Partner.create!(
        :name => "Name",
        :description => "Description",
        :api_key => "Api Key"
      ),
      Partner.create!(
        :name => "Name",
        :description => "Description",
        :api_key => "Api Key"
      )
    ])
  end

  it "renders a list of partners" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Api Key".to_s, :count => 2
  end
end
