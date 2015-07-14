class DropActivityTemplatesDeviceTypes < ActiveRecord::Migration
  def self.up
    drop_table :activity_templates_device_types, {}
  end

  def self.down
    create_table :activity_templates_device_types, :id => false do |t|
      t.references :activity_template, :device_type
    end
    add_index :activity_templates_device_types, [:activity_template_id, :device_type_id],
              name: "activity_templates_device_types_index",
              unique: true
  end
end
