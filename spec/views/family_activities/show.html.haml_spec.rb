require 'rails_helper'

RSpec.describe "family_activities/show", :type => :view do
  before(:each) do
    @family_activity = assign(:family_activity, FamilyActivity.create!(
      :family_id => 1,
      :activity_template_id => 2,
      :name => "Name",
      :description => "Description",
      :rec_min_age => 3,
      :rec_max_age => 4,
      :cost => 5,
      :reward => 6,
      :time_block => 7,
      :restricted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/false/)
  end
end
