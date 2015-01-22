class IndexMembersByUsernameAndFamilyId < ActiveRecord::Migration
  def change
    add_index :members, [:username, :family_id], :unique => true
  end
end
