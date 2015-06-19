class AddMobicipToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :mobicip_password, :string
    add_column :families, :mobicip_id, :string
    add_column :families, :mobicip_token, :string
  end
end
