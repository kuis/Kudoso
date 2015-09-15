class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :themes do |t|
      t.string :name
      t.string :primary_color, limit: 7
      t.string :secondary_color, limit: 7
      t.string :primary_bg_color, limit: 7
      t.string :secondary_bg_color, limit: 7

      t.timestamps null: false
    end
  end
  def self.down
    drop_table :themes
  end
end
