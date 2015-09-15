class AddAttachmentFirmwareToRouterFirmwares < ActiveRecord::Migration
  def self.up
    change_table :router_firmwares do |t|
      t.attachment :firmware
      t.string :firmware_fingerprint
    end
    remove_column :router_firmwares, :url
  end

  def self.down
    remove_attachment :router_firmwares, :firmware
    remove_column :router_firmwares, :firmware_fingerprint
    add_column :router_firmwares, :url, :string
  end
end
