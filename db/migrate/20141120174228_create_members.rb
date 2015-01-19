class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.date :birth_date
      t.boolean :parent
      t.integer :family_id

      t.timestamps
    end

    add_index :members, :family_id
  end
end
