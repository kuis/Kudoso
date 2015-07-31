class AddMobicipFilterToMembers < ActiveRecord::Migration
  def change
    add_column :members, :mobicip_filter, :string
    add_column :devices, :mobicip_device_id, :string
    add_column :devices, :device_name, :string

  end
end
