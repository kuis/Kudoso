class AddKudosToTodoTemplates < ActiveRecord::Migration
  def change
    add_column :todo_templates, :kudos, :integer, default: 0
  end
end
