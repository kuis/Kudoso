class CreateActivityDetails < ActiveRecord::Migration
  def change
    create_table :activity_details do |t|
      t.integer :activity_id
      t.text :metadata

      t.timestamps
    end
  end
end
