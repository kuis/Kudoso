class AddMobicipToMembers < ActiveRecord::Migration
  def change
    add_column :members, :mobicip_profile, :string
  end
end
