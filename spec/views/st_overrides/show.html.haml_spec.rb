require 'rails_helper'

RSpec.describe "st_overrides/show", :type => :view do
  before(:each) do
    @st_override = assign(:st_override, StOverride.create!(
      :member_id => 1,
      :created_by_id => 2,
      :time => 3,
      :comment => "Comment"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Comment/)
  end
end
