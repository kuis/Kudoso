require 'rails_helper'

RSpec.describe "activity_templates/show", :type => :view do
  before(:each) do
    @activity_template = assign(:activity_template, ActivityTemplate.create!(
      :name => "Name",
      :description => "Description",
      :rec_min_age => 1,
      :rec_max_age => 2,
      :cost => 3,
      :reward => 4,
      :time_block => 5,
      :restricted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/false/)
  end
end
