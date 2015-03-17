class CreateApiDevices < ActiveRecord::Migration
  def change
    create_table :api_devices do |t|
      t.string :device_token
      t.string :name
      t.date :expires_at

      t.timestamps
    end
  end
end
