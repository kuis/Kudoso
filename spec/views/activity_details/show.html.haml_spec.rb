require 'rails_helper'

RSpec.describe "activity_details/show", :type => :view do
  before(:each) do
    @activity_detail = assign(:activity_detail, ActivityDetail.create!(
      :activity_id => 1,
      :metadata => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
