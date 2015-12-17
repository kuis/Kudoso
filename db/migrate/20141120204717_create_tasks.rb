class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.boolean :required
      t.integer :kudos
      t.integer :task_template_id
      t.integer :family_id
      t.boolean :active
      t.text :schedule

      t.timestamps
    end
    add_index :tasks, :family_id
    add_index :tasks, :task_template_id
  end
end
