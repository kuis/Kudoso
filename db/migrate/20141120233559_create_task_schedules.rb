class CreateTaskSchedules < ActiveRecord::Migration
  def change
    create_table :task_schedules do |t|
      t.integer :task_id
      t.integer :member_id
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active
      t.text :notes

      t.timestamps
    end

    add_index :task_schedules, :task_id
    add_index :task_schedules, :member_id
  end
end
