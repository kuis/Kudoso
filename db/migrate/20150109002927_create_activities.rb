class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
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
