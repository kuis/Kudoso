class CreateTodoSchedules < ActiveRecord::Migration
  def change
    create_table :todo_schedules do |t|
      t.integer :todo_id
      t.integer :member_id
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active
      t.text :notes

      t.timestamps
    end

    add_index :todo_schedules, :todo_id
    add_index :todo_schedules, :member_id
  end
end
