class AddAttachmentIconToApps < ActiveRecord::Migration
  def self.up
    change_table :apps do |t|
      t.attachment :icon
    end
  end

  def self.down
    remove_attachment :apps, :icon
  end
end
