class AddDeviceCategoryToDeviceType < ActiveRecord::Migration
  def change
    add_column :device_types, :device_category_id, :integer
  end
end
