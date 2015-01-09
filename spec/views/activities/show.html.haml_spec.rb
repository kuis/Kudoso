require 'rails_helper'

RSpec.describe "activities/show", :type => :view do
  before(:each) do
    @activity = assign(:activity, Activity.create!(
      :activity_template_id => 1,
      :name => "Name",
      :description => "Description",
      :rec_min_age => 2,
      :rec_max_age => 3,
      :cost => 4,
      :reward => 5,
      :time_block => 6,
      :restricted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/false/)
  end
end
