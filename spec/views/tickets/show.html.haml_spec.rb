require 'rails_helper'

RSpec.describe "tickets/show", :type => :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :assigned_to_id => 1,
      :user_id => 2,
      :contact_id => 3,
      :ticket_type_id => 4,
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Status/)
  end
end
