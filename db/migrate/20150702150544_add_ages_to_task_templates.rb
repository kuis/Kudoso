class AddAgesToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :rec_min_age, :integer
    add_column :task_templates, :rec_max_age, :integer
    add_column :task_templates, :def_min_age, :integer
    add_column :task_templates, :def_max_age, :integer
    rename_column :task_templates, :active, :disabled
  end
end
