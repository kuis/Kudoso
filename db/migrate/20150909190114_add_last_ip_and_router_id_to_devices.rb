class AddLastIpAndRouterIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :last_ip, :string
    add_column :devices, :mac_address, :string
    add_column :devices, :router_id, :integer
  end
end
