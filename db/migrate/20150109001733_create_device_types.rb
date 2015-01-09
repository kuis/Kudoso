class CreateDeviceTypes < ActiveRecord::Migration
  def change
    create_table :device_types do |t|
      t.string :name
      t.string :description
      t.string :os
      t.string :version

      t.timestamps
    end
  end
end
