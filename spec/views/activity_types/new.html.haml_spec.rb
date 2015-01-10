require 'rails_helper'

RSpec.describe "activity_types/new", :type => :view do
  before(:each) do
    assign(:activity_type, ActivityType.new(
      :name => "MyString"
    ))
  end

  it "renders new activity_type form" do
    render

    assert_select "form[action=?][method=?]", activity_types_path, "post" do

      assert_select "input#activity_type_name[name=?]", "activity_type[name]"
    end
  end
end
