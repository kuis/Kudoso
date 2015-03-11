require 'rails_helper'

RSpec.describe "tickets/edit", :type => :view do
  before(:each) do
    @ticket = assign(:ticket, Ticket.create!(
      :assigned_to_id => 1,
      :user_id => 1,
      :contact_id => 1,
      :ticket_type_id => 1,
      :status => "MyString"
    ))
  end

  it "renders the edit ticket form" do
    render

    assert_select "form[action=?][method=?]", ticket_path(@ticket), "post" do

      assert_select "input#ticket_assigned_to_id[name=?]", "ticket[assigned_to_id]"

      assert_select "input#ticket_user_id[name=?]", "ticket[user_id]"

      assert_select "input#ticket_contact_id[name=?]", "ticket[contact_id]"

      assert_select "input#ticket_ticket_type_id[name=?]", "ticket[ticket_type_id]"

      assert_select "input#ticket_status[name=?]", "ticket[status]"
    end
  end
end
