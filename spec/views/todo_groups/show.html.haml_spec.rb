require 'rails_helper'

RSpec.describe "todo_groups/show", :type => :view do
  before(:each) do
    @todo_group = assign(:todo_group, TodoGroup.create!(
      :name => "Name",
      :rec_min_age => 1,
      :rec_max_age => 2,
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
  end
end
