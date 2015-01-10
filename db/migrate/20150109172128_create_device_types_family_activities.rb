class CreateDeviceTypesFamilyActivities < ActiveRecord::Migration
  def change
    create_table :device_types_family_activities, :id => false do |t|
      t.references :device_type, :family_activity
    end

    add_index :device_types_family_activities, [:device_type_id, :family_activity_id],
      name: "device_types_family_activities_index",
      unique: true
  end
end
