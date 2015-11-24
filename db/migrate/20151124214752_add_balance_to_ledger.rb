class AddBalanceToLedger < ActiveRecord::Migration
  def change
    add_column :ledger_entries, :balance, :integer
  end
end
