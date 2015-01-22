class AddDeviseToMembers < ActiveRecord::Migration
  def change
    add_column :members, :encrypted_password, :string, :null => false, :default => '', :limit => 128
    remove_column :members, :password
    change_table :members do |t|
      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Token authenticatable
      t.string :authentication_token
    end
  end
end
