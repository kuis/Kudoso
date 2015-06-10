class CreateFamilyDeviceCategories < ActiveRecord::Migration
  def change
    create_table :family_device_categories do |t|
      t.integer :family_id
      t.integer :device_category_id
      t.integer :amount, default: 0

      t.timestamps null: false
    end
  end
end
