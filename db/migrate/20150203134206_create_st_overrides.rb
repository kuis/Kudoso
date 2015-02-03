class CreateStOverrides < ActiveRecord::Migration
  def change
    create_table :st_overrides do |t|
      t.integer :member_id
      t.integer :created_by_id
      t.integer :time
      t.datetime :date
      t.string :comment

      t.timestamps
    end

    add_index :st_overrides, :member_id
    add_index :st_overrides, [:member_id, :date]
  end
end
