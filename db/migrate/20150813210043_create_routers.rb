class CreateRouters < ActiveRecord::Migration
  def change
    create_table :routers do |t|
      t.integer :router_model_id
      t.integer :router_firmware_id
      t.integer :family_id
      t.string :last_known_ip
      t.datetime :last_seen
      t.datetime :last_firmware_update
      t.string :mac_address
      t.string :secure_key
      t.boolean :registered

      t.timestamps null: false
    end
    add_index :routers, :mac_address
  end
end
