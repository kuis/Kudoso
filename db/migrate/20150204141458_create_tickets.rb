class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :assigned_to_id
      t.integer :user_id
      t.integer :contact_id
      t.integer :ticket_type_id
      t.datetime :date_openned
      t.datetime :date_closed
      t.string :status

      t.timestamps
    end
  end
end
