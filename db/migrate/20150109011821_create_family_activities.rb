class CreateFamilyActivities < ActiveRecord::Migration
  def change
    create_table :family_activities do |t|
      t.integer :family_id
      t.integer :activity_template_id
      t.string :name
      t.string :description
      t.integer :rec_min_age
      t.integer :rec_max_age
      t.integer :cost
      t.integer :reward
      t.integer :time_block
      t.boolean :restricted

      t.timestamps
    end
  end
end
