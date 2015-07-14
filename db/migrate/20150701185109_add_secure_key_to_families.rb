class AddSecureKeyToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :secure_key, :string
  end
end
