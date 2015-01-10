require 'rails_helper'

RSpec.describe "activity_details/new", :type => :view do
  before(:each) do
    assign(:activity_detail, ActivityDetail.new(
      :activity_id => 1,
      :metadata => "MyText"
    ))
  end

  it "renders new activity_detail form" do
    render

    assert_select "form[action=?][method=?]", activity_details_path, "post" do

      assert_select "input#activity_detail_activity_id[name=?]", "activity_detail[activity_id]"

      assert_select "textarea#activity_detail_metadata[name=?]", "activity_detail[metadata]"
    end
  end
end
