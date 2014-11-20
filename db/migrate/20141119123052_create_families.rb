class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.string :name
      t.integer :primary_contact_id

      t.timestamps
    end
  end
end
