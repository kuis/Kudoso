class TodoGroupsTodoTemplates < ActiveRecord::Migration
  def self.up
    create_table :todo_groups_todo_templates, :id => false do |t|
      t.references :todo_group
      t.references :todo_template
    end
    add_index :todo_groups_todo_templates, [:todo_group_id, :todo_template_id], name: 'todo_group_template_habtm_idx'
    add_index :todo_groups_todo_templates, :todo_template_id
  end

  def self.down
    drop_table :todo_groups_todo_templates
  end
end
