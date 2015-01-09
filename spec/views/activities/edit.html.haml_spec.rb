require 'rails_helper'

RSpec.describe "activities/edit", :type => :view do
  before(:each) do
    @activity = assign(:activity, Activity.create!(
      :member_id => 1,
      :family_activity_id => 1,
      :date => "",
      :duration => 1,
      :device_id => 1,
      :notes => "MyText"
    ))
  end

  it "renders the edit activity form" do
    render

    assert_select "form[action=?][method=?]", activity_path(@activity), "post" do

      assert_select "input#activity_member_id[name=?]", "activity[member_id]"

      assert_select "input#activity_family_activity_id[name=?]", "activity[family_activity_id]"

      assert_select "input#activity_date[name=?]", "activity[date]"

      assert_select "input#activity_duration[name=?]", "activity[duration]"

      assert_select "input#activity_device_id[name=?]", "activity[device_id]"

      assert_select "textarea#activity_notes[name=?]", "activity[notes]"
    end
  end
end
