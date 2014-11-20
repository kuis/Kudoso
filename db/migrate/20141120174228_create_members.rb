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
      t.integer :user_id

      t.timestamps
    end
  end
end
