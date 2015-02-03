require 'rails_helper'

RSpec.describe "st_overrides/new", :type => :view do
  before(:each) do
    assign(:st_override, StOverride.new(
      :member_id => 1,
      :created_by_id => 1,
      :time => 1,
      :comment => "MyString"
    ))
  end

  it "renders new st_override form" do
    render

    assert_select "form[action=?][method=?]", st_overrides_path, "post" do

      assert_select "input#st_override_member_id[name=?]", "st_override[member_id]"

      assert_select "input#st_override_created_by_id[name=?]", "st_override[created_by_id]"

      assert_select "input#st_override_time[name=?]", "st_override[time]"

      assert_select "input#st_override_comment[name=?]", "st_override[comment]"
    end
  end
end
