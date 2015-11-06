class CreateActivitiesDevices < ActiveRecord::Migration
  def change
    create_join_table :activities, :devices do |t|
      t.index [:activity_id, :device_id]
      t.index [:device_id, :activity_id]
    end
  end
end
