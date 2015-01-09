class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :member_id
      t.integer :family_activity_id
      t.date_time :date
      t.integer :duration
      t.integer :device_id
      t.text :notes

      t.timestamps
    end
  end
end
