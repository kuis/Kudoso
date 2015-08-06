class AddGenderToMembers < ActiveRecord::Migration
  def change
    add_column :members, :gender, :string, limit: 1
  end
end
