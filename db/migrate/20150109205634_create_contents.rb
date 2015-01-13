class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :content_type_id
      t.string :title
      t.string :year
      t.integer :content_rating_id
      t.date :release_date
      t.integer :language_id
      t.text :description
      t.string :length
      t.text :metadata
      t.text :references

      t.timestamps
    end

    add_index :contents, :content_type_id
    add_index :contents, :content_rating_id
  end
end
