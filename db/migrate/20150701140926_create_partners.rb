class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :description
      t.string :api_key

      t.timestamps null: false
    end
  end
end
