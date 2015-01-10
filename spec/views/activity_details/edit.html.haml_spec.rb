require 'rails_helper'

RSpec.describe "activity_details/edit", :type => :view do
  before(:each) do
    @activity_detail = assign(:activity_detail, ActivityDetail.create!(
      :activity_id => 1,
      :metadata => "MyText"
    ))
  end

  it "renders the edit activity_detail form" do
    render

    assert_select "form[action=?][method=?]", activity_detail_path(@activity_detail), "post" do

      assert_select "input#activity_detail_activity_id[name=?]", "activity_detail[activity_id]"

      assert_select "textarea#activity_detail_metadata[name=?]", "activity_detail[metadata]"
    end
  end
end
