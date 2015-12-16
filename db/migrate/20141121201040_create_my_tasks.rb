class CreateMyTasks < ActiveRecord::Migration
  def change
    create_table :my_tasks do |t|
      t.integer :task_schedule_id
      t.integer :member_id
      t.datetime :due_date
      t.datetime :due_time
      t.boolean :complete
      t.boolean :verify
      t.datetime :verified_at
      t.integer :verified_by

      t.timestamps
    end

    add_index :my_tasks, :member_id
    add_index :my_tasks, :task_schedule_id
  end
end
