class RemoveDeviceIdFromActivities < ActiveRecord::Migration
  def self.up
    remove_column :activities, :device_id
  end

  def self.down
    add_column :activities, :device_id, :integer
  end
end
