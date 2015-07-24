class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.integer :device_id
      t.string :name
      t.boolean :executed
      t.datetime :sent
      t.integer :status
      t.string :result

      t.timestamps null: false
    end
  end
end
