class AddKudosToTaskTemplates < ActiveRecord::Migration
  def change
    add_column :task_templates, :kudos, :integer, default: 0
  end
end
