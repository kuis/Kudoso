require 'rails_helper'

RSpec.describe "activity_types/edit", :type => :view do
  before(:each) do
    @activity_type = assign(:activity_type, ActivityType.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit activity_type form" do
    render

    assert_select "form[action=?][method=?]", activity_type_path(@activity_type), "post" do

      assert_select "input#activity_type_name[name=?]", "activity_type[name]"
    end
  end
end
