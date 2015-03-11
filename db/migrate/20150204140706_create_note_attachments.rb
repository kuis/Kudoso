class CreateNoteAttachments < ActiveRecord::Migration
  def change
    create_table :note_attachments do |t|
      t.integer :note_id
      t.string :name

      t.timestamps
    end
  end
end
