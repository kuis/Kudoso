class CreateScreenTimeSchedules < ActiveRecord::Migration
  def change
    create_table :screen_time_schedules do |t|
      t.integer :family_id
      t.integer :member_id
      t.text :restrictions

      t.timestamps
    end
  end
end
