class AddAttribtutesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :admin, :boolean
    add_column :users, :parent, :boolean
    add_column :users, :household_id, :integer
  end
end
