class AddStipeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_account_current, :boolean
    add_column :users, :stripe_customer_id, :string
    add_column :users, :plan_expiration, :date
  end
end
