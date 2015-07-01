class AddExternalIdToActivityTemplates < ActiveRecord::Migration
  def change
    add_column :activity_templates, :external_id, :string
  end
end
