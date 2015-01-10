require 'rails_helper'

RSpec.describe "content_ratings/show", :type => :view do
  before(:each) do
    @content_rating = assign(:content_rating, ContentRating.create!(
      :type => "Type",
      :tag => "Tag",
      :short => "Short",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/Tag/)
    expect(rendered).to match(/Short/)
    expect(rendered).to match(/MyText/)
  end
end
