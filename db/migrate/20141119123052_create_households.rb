class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string :name
      t.integer :primary_contact_id

      t.timestamps
    end
  end
end
