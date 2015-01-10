require 'rails_helper'

RSpec.describe "content_descriptors/show", :type => :view do
  before(:each) do
    @content_descriptor = assign(:content_descriptor, ContentDescriptor.create!(
      :tag => "Tag",
      :short => "Short",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Tag/)
    expect(rendered).to match(/Short/)
    expect(rendered).to match(/MyText/)
  end
end
