class AddAgesToTodoTemplates < ActiveRecord::Migration
  def change
    add_column :todo_templates, :rec_min_age, :integer
    add_column :todo_templates, :rec_max_age, :integer
    add_column :todo_templates, :def_min_age, :integer
    add_column :todo_templates, :def_max_age, :integer
    rename_column :todo_templates, :active, :disabled
  end
end
