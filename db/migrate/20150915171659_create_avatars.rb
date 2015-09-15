class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :name
      t.string :gender
      t.integer :theme_id

      t.timestamps null: false
    end
  end
end
