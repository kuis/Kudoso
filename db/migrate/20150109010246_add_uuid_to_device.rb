class AddUuidToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :uuid, :string
  end
end
