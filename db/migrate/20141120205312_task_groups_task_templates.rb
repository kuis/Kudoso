class TaskGroupsTaskTemplates < ActiveRecord::Migration
  def self.up
    create_table :task_groups_task_templates, :id => false do |t|
      t.references :task_group
      t.references :task_template
    end
    add_index :task_groups_task_templates, [:task_group_id, :task_template_id], name: 'task_group_template_habtm_idx'
    add_index :task_groups_task_templates, :task_template_id
  end

  def self.down
    drop_table :task_groups_task_templates
  end
end
