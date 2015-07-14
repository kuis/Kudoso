class AddDisabledToActivityTemplates < ActiveRecord::Migration
  def change
    add_column :activity_templates, :disabled, :boolean
  end
end
