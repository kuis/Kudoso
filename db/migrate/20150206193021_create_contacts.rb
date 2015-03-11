class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.integer :primary_email_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.integer :address_type_id
      t.string :phone
      t.integer :phone_type_id
      t.datetime :last_contact
      t.boolean :do_not_call
      t.boolean :do_not_email
      t.integer :contact_type_id

      t.timestamps
    end
  end
end
