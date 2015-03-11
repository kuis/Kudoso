require 'rails_helper'

RSpec.describe "contacts/index", :type => :view do
  before(:each) do
    assign(:contacts, [
      Contact.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :company => "Company",
        :primary_email_id => 1,
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zip => "Zip",
        :address_type_id => 2,
        :phone => "Phone",
        :phone_type_id => 3,
        :do_not_call => false,
        :do_not_email => false,
        :contact_type_id => 4
      ),
      Contact.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :company => "Company",
        :primary_email_id => 1,
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :state => "State",
        :zip => "Zip",
        :address_type_id => 2,
        :phone => "Phone",
        :phone_type_id => 3,
        :do_not_call => false,
        :do_not_email => false,
        :contact_type_id => 4
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Company".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Address1".to_s, :count => 2
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
