class AddAttribtutesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :admin, :boolean, default: false, null: false
    add_column :users, :family_id, :integer
    add_column :users, :member_id, :integer
  end
end
