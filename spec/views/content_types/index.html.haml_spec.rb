require 'rails_helper'

RSpec.describe "content_types/index", :type => :view do
  before(:each) do
    assign(:content_types, [
      ContentType.create!(
        :name => "Name"
      ),
      ContentType.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of content_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
