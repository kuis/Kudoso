class CreateTodoGroups < ActiveRecord::Migration
  def change
    create_table :todo_groups do |t|
      t.string :name
      t.integer :rec_min_age
      t.integer :rec_max_age
      t.boolean :active

      t.timestamps
    end
  end
end
