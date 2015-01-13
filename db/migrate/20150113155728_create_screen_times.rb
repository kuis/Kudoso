class CreateScreenTimes < ActiveRecord::Migration
  def change
    create_table :screen_times do |t|
      t.integer :member_id
      t.integer :device_id
      t.integer :dow
      t.integer :maxtime

      t.timestamps
    end
    add_index :screen_times, :member_id
    add_index :screen_times, :device_id
  end
end
