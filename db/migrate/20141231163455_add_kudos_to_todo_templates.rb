class AddKudosToTodoTemplates < ActiveRecord::Migration
  def change
    add_column :todo_templates, :kudos, :integer
  end
end
