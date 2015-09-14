class CreateAppMembers < ActiveRecord::Migration
  def change
    create_table :app_members do |t|
      t.integer :app_id
      t.integer :member_id
      t.boolean :restricted

      t.timestamps null: false
    end
  end
end
