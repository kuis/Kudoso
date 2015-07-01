class AddActivityTemplateIdToActivities < ActiveRecord::Migration
  def self.up
    remove_index :activities, :family_activity_id
    add_column :activities, :activity_template_id, :integer
    remove_column :activities, :activity_type_id, :integer
    remove_column :activities, :family_activity_id, :integer
  end

  def self.down
    remove_column :activities, :activity_template_id, :integer
    add_column :activities, :activity_type_id, :integer
    add_column :activities, :family_activity_id, :integer
    add_index :activities, :family_activity_id

  end
end
