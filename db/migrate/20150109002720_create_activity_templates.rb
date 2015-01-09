class CreateActivityTemplates < ActiveRecord::Migration
  def change
    create_table :activity_templates do |t|
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
