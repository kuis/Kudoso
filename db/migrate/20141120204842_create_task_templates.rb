class CreateTaskTemplates < ActiveRecord::Migration
  def change
    create_table :task_templates do |t|
      t.string :name
      t.string :description
      t.boolean :required
      t.string :schedule
      t.boolean :active

      t.timestamps
    end
  end
end
