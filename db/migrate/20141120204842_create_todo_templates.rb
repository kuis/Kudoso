class CreateTodoTemplates < ActiveRecord::Migration
  def change
    create_table :todo_templates do |t|
      t.string :name
      t.string :description
      t.string :schedule
      t.string :active

      t.timestamps
    end
  end
end
