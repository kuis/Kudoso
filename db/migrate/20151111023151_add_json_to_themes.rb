class AddJsonToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :json, :text
    remove_column :themes, :primary_color, :string, limit: 7
    remove_column :themes, :secondary_color, :string, limit: 7
    remove_column :themes, :primary_bg_color, :string, limit: 7
    remove_column :themes, :secondary_bg_color, :string, limit: 7
  end
end
