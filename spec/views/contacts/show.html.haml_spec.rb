require 'rails_helper'

RSpec.describe "contacts/show", :type => :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Company/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Address1/)
    expect(rendered).to match(/Address2/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Zip/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
  end
end
