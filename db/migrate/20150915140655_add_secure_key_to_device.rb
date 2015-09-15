class AddSecureKeyToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :secure_key, :string
  end
end
