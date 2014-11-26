class CreateMyTodos < ActiveRecord::Migration
  def change
    create_table :my_todos do |t|
      t.integer :todo_schedule_id
      t.integer :member_id
      t.date :due_date
      t.datetime :due_time
      t.boolean :complete
      t.boolean :verify
      t.datetime :verified_at
      t.integer :verified_by

      t.timestamps
    end
  end
end
