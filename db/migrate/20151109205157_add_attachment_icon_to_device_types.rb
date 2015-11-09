class AddAttachmentIconToDeviceTypes < ActiveRecord::Migration
  def self.up
    change_table :device_types do |t|
      t.attachment :icon
    end
  end

  def self.down
    remove_attachment :device_types, :icon
  end
end
