require 'rails_helper'

RSpec.describe "activities/show", :type => :view do
  before(:each) do
    @activity = assign(:activity, Activity.create!(
      :member_id => 1,
      :created_by => 2,
      :family_activity_id => 3,
      :device_id => 4,
      :content_id => 5,
      :allowed_time => 6,
      :activity_type_id => 7,
      :cost => 8,
      :reward => 9
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
    expect(rendered).to match(/9/)
  end
end
