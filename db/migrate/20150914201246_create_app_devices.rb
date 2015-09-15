class CreateAppDevices < ActiveRecord::Migration
  def change
    create_table :app_devices do |t|
      t.integer :app_id
      t.integer :device_id
      t.string :version
      t.datetime :installed_at

      t.timestamps null: false
    end
  end
end
