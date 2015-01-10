class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name
      t.integer :device_type_id
      t.integer :family_id
      t.boolean :managed, default: false
      t.integer :management_id
      t.integer :primary_member_id

      t.timestamps
    end
  end
end
