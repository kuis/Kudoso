class CreateScreenTimeScheduleRrules < ActiveRecord::Migration
  def change
    create_table :screen_time_schedule_rrules do |t|
      t.integer :screen_time_schedule_id
      t.string :rrule

      t.timestamps
    end

    add_index :screen_time_schedule_rrules, :screen_time_schedule_id

  end
end
