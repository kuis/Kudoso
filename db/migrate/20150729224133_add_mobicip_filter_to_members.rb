class AddMobicipFilterToMembers < ActiveRecord::Migration
  def change
    add_column :members, :mobicip_filter, :string

  end
end
