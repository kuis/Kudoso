class AddChecksumToRouterFirmwares < ActiveRecord::Migration
  def change
    add_column :router_firmwares, :checksum, :string
  end
end
