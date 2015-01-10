require 'rails_helper'

RSpec.describe "activity_types/show", :type => :view do
  before(:each) do
    @activity_type = assign(:activity_type, ActivityType.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
