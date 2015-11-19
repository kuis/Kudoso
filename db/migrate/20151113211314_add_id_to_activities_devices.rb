class AddIdToActivitiesDevices < ActiveRecord::Migration
  def change
    add_column :activities_devices, :id, :primary_key
  end
end
