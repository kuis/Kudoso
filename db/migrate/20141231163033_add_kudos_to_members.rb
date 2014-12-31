class AddKudosToMembers < ActiveRecord::Migration
  def change
    add_column :members, :kudos, :integer
  end
end
