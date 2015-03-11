require 'rails_helper'

RSpec.describe "contacts/new", :type => :view do
  before(:each) do
    assign(:contact, Contact.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :company => "MyString",
      :primary_email_id => 1,
      :address1 => "MyString",
      :address2 => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString",
      :address_type_id => 1,
      :phone => "MyString",
      :phone_type_id => 1,
      :do_not_call => false,
      :do_not_email => false,
      :contact_type_id => 1
    ))
  end

  it "renders new contact form" do
    render

    assert_select "form[action=?][method=?]", contacts_path, "post" do

      assert_select "input#contact_first_name[name=?]", "contact[first_name]"

      assert_select "input#contact_last_name[name=?]", "contact[last_name]"

      assert_select "input#contact_company[name=?]", "contact[company]"

      assert_select "input#contact_primary_email_id[name=?]", "contact[primary_email_id]"

      assert_select "input#contact_address1[name=?]", "contact[address1]"

      assert_select "input#contact_address2[name=?]", "contact[address2]"

      assert_select "input#contact_city[name=?]", "contact[city]"

      assert_select "input#contact_state[name=?]", "contact[state]"

      assert_select "input#contact_zip[name=?]", "contact[zip]"

      assert_select "input#contact_address_type_id[name=?]", "contact[address_type_id]"

      assert_select "input#contact_phone[name=?]", "contact[phone]"

      assert_select "input#contact_phone_type_id[name=?]", "contact[phone_type_id]"

      assert_select "input#contact_do_not_call[name=?]", "contact[do_not_call]"

      assert_select "input#contact_do_not_email[name=?]", "contact[do_not_email]"

      assert_select "input#contact_contact_type_id[name=?]", "contact[contact_type_id]"
    end
  end
end
