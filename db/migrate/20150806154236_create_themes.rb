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
    Theme.create({ name: 'Kudoso', primary_color: '#1E387E', secondary_color: '#FDB941', primary_bg_color: '#4F9CF6', secondary_bg_color: '#A5CFFF'})
  end
  def self.down
    drop_table :themes
  end
end
