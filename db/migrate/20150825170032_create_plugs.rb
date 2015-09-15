class CreatePlugs < ActiveRecord::Migration
  def change
    create_table :plugs do |t|
      t.string :mac_address
      t.string :serial
      t.string :secure_key
      t.datetime :last_seen
      t.string :last_known_ip
      t.boolean :registered
      t.references :device

      t.timestamps null: false
    end
  end
end
