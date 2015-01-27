class CreateScreenTimes < ActiveRecord::Migration
  def change
    create_table :screen_times do |t|
      t.integer :member_id
      t.integer :dow
      t.integer :default_time
      t.integer :max_time
      t.text :restrictions

      t.timestamps
    end
    add_index :screen_times, :member_id
    add_index :screen_times, [:member_id, :dow]
  end
end
