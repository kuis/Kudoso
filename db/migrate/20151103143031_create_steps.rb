class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :stepable, polymorphic: true, index: true
      t.text :steps

      t.timestamps null: false
    end
  end
end
