require 'rails_helper'

RSpec.describe "content_descriptors/index", :type => :view do
  before(:each) do
    assign(:content_descriptors, [
      ContentDescriptor.create!(
        :tag => "Tag",
        :short => "Short",
        :description => "MyText"
      ),
      ContentDescriptor.create!(
        :tag => "Tag",
        :short => "Short",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of content_descriptors" do
    render
    assert_select "tr>td", :text => "Tag".to_s, :count => 2
    assert_select "tr>td", :text => "Short".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
