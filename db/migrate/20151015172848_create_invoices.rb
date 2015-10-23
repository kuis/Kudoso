class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :closed_on
      t.text :description
      t.integer :amount

      t.timestamps null: false
    end
  end
end
