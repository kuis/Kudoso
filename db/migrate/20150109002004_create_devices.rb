class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :device_type_id
      t.integer :family_id
      t.boolean :managed, default: false
      t.integer :management_id
      t.integer :primary_member_id
      t.integer :current_activity_id

      t.timestamps
    end

    add_index :devices, :family_id
    add_index :devices, :device_type_id
  end
end
