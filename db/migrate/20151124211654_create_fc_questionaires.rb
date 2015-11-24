class CreateFcQuestionaires < ActiveRecord::Migration
  def change
    create_table :fc_questionaires do |t|
      t.references :contact, index: true, foreign_key: true
      t.integer :kids_2_6
      t.integer :kids_7_12
      t.integer :kids_13_18
      t.integer :mobile_devices
      t.integer :consumer_electronics
      t.integer :computers
      t.string :favorite_feature
      t.boolean :prefer_buy
      t.text :comments

      t.timestamps null: false
    end
  end
end
