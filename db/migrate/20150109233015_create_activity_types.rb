class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.string :name
      t.text :metadata_fields
      t.timestamps
    end
  end
end
