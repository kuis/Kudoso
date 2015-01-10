class CreateContentDescriptors < ActiveRecord::Migration
  def change
    create_table :content_descriptors do |t|
      t.string :tag
      t.string :short
      t.text :description

      t.timestamps
    end
  end
end
