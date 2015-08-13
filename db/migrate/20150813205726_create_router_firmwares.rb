class CreateRouterFirmwares < ActiveRecord::Migration
  def self.up
    create_table :router_firmwares do |t|
      t.integer :router_model_id
      t.string :version
      t.string :url
      t.text :notes

      t.timestamps null: false
    end
    firmware = RouterFirmware.create({router_model_id: 0, version: '1.0.0.d2b80a7', url: 'http://www.kudoso.com/'})
  end
  def self.down
    drop_table :router_firmwares
  end
end
