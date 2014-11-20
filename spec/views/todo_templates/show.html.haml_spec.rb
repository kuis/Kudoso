require 'rails_helper'

RSpec.describe "todo_templates/show", :type => :view do
  before(:each) do
    @todo_template = assign(:todo_template, TodoTemplate.create!(
      :name => "Name",
      :description => "Description",
      :schedule => "Schedule",
      :active => "Active"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Schedule/)
    expect(rendered).to match(/Active/)
  end
end
