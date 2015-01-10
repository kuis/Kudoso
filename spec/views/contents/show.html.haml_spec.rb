require 'rails_helper'

RSpec.describe "contents/show", :type => :view do
  before(:each) do
    @content = assign(:content, Content.create!(
      :content_type_id => 1,
      :title => "Title",
      :year => "Year",
      :content_rating_id => 2,
      :language_id => 3,
      :description => "MyText",
      :length => "Length",
      :metadata => "MyText",
      :references => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Year/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Length/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
