class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :ticket_id
      t.integer :note_type_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
