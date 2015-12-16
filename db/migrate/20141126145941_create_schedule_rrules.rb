class CreateScheduleRrules < ActiveRecord::Migration
  def change
    create_table :schedule_rrules do |t|
      t.integer :task_schedule_id
      t.string :rrule

      t.timestamps
    end

    add_index :schedule_rrules, :task_schedule_id
  end
end
