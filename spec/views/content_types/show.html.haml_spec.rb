require 'rails_helper'

RSpec.describe "content_types/show", :type => :view do
  before(:each) do
    @content_type = assign(:content_type, ContentType.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
