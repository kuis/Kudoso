require 'rails_helper'

RSpec.describe "todo_schedules/show", :type => :view do
  before(:each) do
    @todo_schedule = assign(:todo_schedule, TodoSchedule.create!(
      :todo_id => 1,
      :member_id => 2,
      :active => false,
      :schedule => "MyText",
      :notes => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
