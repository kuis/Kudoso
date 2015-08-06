class AddThemeToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :theme_id, :integer
    theme = Theme.first
    Member.find_each do |member|
      member.update_attribute(:theme_id, theme.id)
    end
  end
  def self.down
    remove_column :members, :theme_id
  end
end
