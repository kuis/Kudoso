class CreateApplogs < ActiveRecord::Migration
  def change
    create_table :applogs do |t|
      t.references :app, index: true, foreign_key: true
      t.references :device, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
