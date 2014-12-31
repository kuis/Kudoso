class AddKudosToMembers < ActiveRecord::Migration
  def change
    add_column :members, :kudos, :integer, default: 0
  end
end
