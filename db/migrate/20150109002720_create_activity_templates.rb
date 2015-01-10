class CreateActivityTemplates < ActiveRecord::Migration
  def change
    create_table :activity_templates do |t|
      t.string :name
      t.string :description
      t.integer :rec_min_age
      t.integer :rec_max_age
      t.integer :cost, default: 0
      t.integer :reward, default: 0
      t.integer :time_block
      t.integer :activity_type_id
      t.boolean :restricted, default: false

      t.timestamps
    end
  end
end
