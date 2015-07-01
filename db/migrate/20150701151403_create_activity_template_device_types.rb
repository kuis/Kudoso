class CreateActivityTemplateDeviceTypes < ActiveRecord::Migration
  def change
    create_table :activity_template_device_types do |t|
      t.integer :activity_template_id
      t.integer :device_type_id
      t.string :type
      t.string :launch_url
      t.string :app_name
      t.string :app_id
      t.string :app_store_url

      t.timestamps null: false
    end
  end
end
