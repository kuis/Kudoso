class CreateLedgerEntries < ActiveRecord::Migration
  def change
    create_table :ledger_entries do |t|
      t.references :member, index: true, foreign_key: true
      t.integer :debit
      t.integer :credit
      t.string :description

      t.timestamps null: false
    end
  end
end
