require 'rails_helper'

RSpec.describe "activity_details/index", :type => :view do
  before(:each) do
    assign(:activity_details, [
      ActivityDetail.create!(
        :activity_id => 1,
        :metadata => "MyText"
      ),
      ActivityDetail.create!(
        :activity_id => 1,
        :metadata => "MyText"
      )
    ])
  end

  it "renders a list of activity_details" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
