class AddAttrsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :udid, :string
    add_column :devices, :wifi_mac, :string
    add_column :devices, :last_contact, :datetime
    add_column :devices, :os_version, :string
    add_column :devices, :build_version, :string
    add_column :devices, :product_name, :string
  end
end
