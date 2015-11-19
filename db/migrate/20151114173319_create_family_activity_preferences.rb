class CreateFamilyActivityPreferences < ActiveRecord::Migration
  def change
    create_table :family_activity_preferences do |t|
      t.references :activity_template, index: true, foreign_key: true
      t.references :family, index: true, foreign_key: true
      t.integer :cost
      t.integer :reward
      t.integer :time_block
      t.boolean :preferred
      t.boolean :restricted

      t.timestamps null: false
    end
  end
end
