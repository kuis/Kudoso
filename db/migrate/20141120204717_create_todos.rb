class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :name
      t.string :description
      t.boolean :required
      t.integer :kudos
      t.integer :todo_template_id
      t.integer :family_id
      t.boolean :active
      t.text :schedule

      t.timestamps
    end
  end
end
