require 'rails_helper'

RSpec.describe "tickets/index", :type => :view do
  before(:each) do
    assign(:tickets, [
      Ticket.create!(
        :assigned_to_id => 1,
        :user_id => 2,
        :contact_id => 3,
        :ticket_type_id => 4,
        :status => "Status"
      ),
      Ticket.create!(
        :assigned_to_id => 1,
        :user_id => 2,
        :contact_id => 3,
        :ticket_type_id => 4,
        :status => "Status"
      )
    ])
  end

  it "renders a list of tickets" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
