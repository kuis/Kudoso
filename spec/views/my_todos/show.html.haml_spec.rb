require 'rails_helper'

RSpec.describe "my_todos/show", :type => :view do
  before(:each) do
    @my_todo = assign(:my_todo, MyTodo.create!(
      :todo_schedule_id => 1,
      :member_id => 2,
      :complete => false,
      :verify => false,
      :verified_by => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/3/)
  end
end
